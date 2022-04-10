// BalzRegister.cpp

#include "StdAfx.h"

#include "BalzEncoder.h"
#include "../../Common/StreamUtils.h"

// balz.cpp is written and placed in the public domain by Ilya Muravyov

#include <vector>
#include <stdlib.h>

typedef unsigned char byte;
typedef unsigned short ushort;
typedef unsigned int uint;
typedef unsigned long long ulonglong;

// Globals

namespace NCompress {
namespace NBALZ {

//FILE* in;
//FILE* out;

static void putC_enc(unsigned char c, void *w_);
static int read_enc(void *w_, size_t size, void *buf);
//static int getC_enc(void *w_);

static int write_dec(void *r_, size_t size, unsigned char *buf);
//static void putC_dec(unsigned char c, void *r_);
static int read_dec(void *r_, size_t size, void *buf);
static int getC_dec(void *r_);

class Counter
{
public:
	ushort p1;
	ushort p2;

	Counter()
		: p1(1<<15), p2(1<<15)
	{}

	uint P() const
	{
		return p1+p2;
	}

	void Update0()
	{
		p1-=p1>>3;
		p2-=p2>>6;
	}

	void Update1()
	{
		p1+=(p1^65535)>>3;
		p2+=(p2^65535)>>6;
	}
};

class Encoder
{
public:
	uint code;
	uint low;
	uint high;
	void *in;
	void *out;

	Encoder(void *in_, void *out_) :
		code(0), low(0), high(-1),
		in(in_), out(out_)
	{}

	void Encode(int bit, Counter& counter)
	{
		const uint mid=low+((ulonglong(high-low)*counter.P())>>17);

		if (bit)
		{
			high=mid;
			counter.Update1();
		}
		else
		{
			low=mid+1;
			counter.Update0();
		}

		while ((low^high)<(1<<24))
		{
			putC_enc(low>>24, out);
			low<<=8;
			high=(high<<8)|255;
		}
	}

	void Encode1(int bit, uint p)
	{
		const uint mid=low+((ulonglong(high-low)*p)>>1);

		if (bit)
		{
			high=mid;
		}
		else
		{
			low=mid+1;
		}

		while ((low^high)<(1<<24))
		{
			putC_enc(low>>24, out);
			low<<=8;
			high=(high<<8)|255;
		}
	}

	void Flush()
	{
		for (int i=0; i<4; ++i)
		{
			putC_enc(low>>24, out);
			low<<=8;
		}
	}

	void Init()
	{
		for (int i=0; i<4; ++i)
			code=(code<<8)|getC_dec(in);
	}

	int Decode(Counter& counter)
	{
		const uint mid=low+((ulonglong(high-low)*counter.P())>>17);

		const int bit=(code<=mid);
		if (bit)
		{
			high=mid;
			counter.Update1();
		}
		else
		{
			low=mid+1;
			counter.Update0();
		}

		while ((low^high)<(1<<24))
		{
			code=(code<<8)|getC_dec(in);
			low<<=8;
			high=(high<<8)|255;
		}

		return bit;
	}

	int Decode1(uint p)
	{
		const uint mid=low+((ulonglong(high-low)*p)>>1);

		const int bit=(code<=mid);
		if (bit)
		{
			high=mid;
		}
		else
		{
			low=mid+1;
		}

		while ((low^high)<(1<<24))
		{
			code=(code<<8)|getC_dec(in);
			low<<=8;
			high=(high<<8)|255;
		}

		return bit;
	}

	void Put32(uint x)
	{
		for (uint i=1u<<31; i>0; i>>=1)
			Encode1(x&i, 1); // p=0.5
	}

	uint Get32()
	{
		uint x=0;
		for (int i=0; i<32; ++i)
			x+=x+Decode1(1); // p=0.5
		return x;
	}
};

const int TAB_BITS=7;
const int TAB_SIZE=1<<TAB_BITS;
const int TAB_MASK=TAB_SIZE-1;

class CM: public Encoder
{
public:
	Counter counter1[256][512];
	Counter counter2[256][TAB_SIZE];

	CM(void *in_, void *out_): Encoder(in_, out_){}

	void Encode(int t, int c1)
	{
		int ctx=1;
		while (ctx<512)
		{
			const int bit=((t&256)!=0);
			t+=t;
			Encoder::Encode(bit, counter1[c1][ctx]);
			ctx+=ctx+bit;
		}
	}

	void EncodeIdx(int x, int c2)
	{
		int ctx=1;
		while (ctx<TAB_SIZE)
		{
			const int bit=((x&(TAB_SIZE>>1))!=0);
			x+=x;
			Encoder::Encode(bit, counter2[c2][ctx]);
			ctx+=ctx+bit;
		}
	}

	int Decode(int c1)
	{
		int ctx=1;
		while (ctx<512)
			ctx+=ctx+Encoder::Decode(counter1[c1][ctx]);

		return ctx-512;
	}

	int DecodeIdx(int c2)
	{
		int ctx=1;
		while (ctx<TAB_SIZE)
			ctx+=ctx+Encoder::Decode(counter2[c2][ctx]);

		return ctx-TAB_SIZE;
	}
};

const int MIN_MATCH=3;
const int MAX_MATCH=255+MIN_MATCH;

class Compressor{
	const uint BUF_BITS;
	const uint BUF_SIZE;
	const uint BUF_MASK;

	std::vector<byte> buf;
	std::vector<std::vector<uint> > tab;
	std::vector<int> cnt;
        void *in;
        void *out;
        CM cm;
	
template<bool FWD>
void e8e9_transform(int n)
{
	const int end=n-8;
	int p=0;

	while ((reinterpret_cast<int&>(buf[p])!=0x4550)&&(++p<end));

	while (p<end)
	{
		if ((buf[p++]&254)==0xe8)
		{
			int& addr=reinterpret_cast<int&>(buf[p]);
			if (FWD)
			{
				if ((addr>=-p)&&(addr<(n-p)))
					addr+=p;
				else if ((addr>0)&&(addr<n))
					addr-=n;
			}
			else
			{
				if (addr<0)
				{
					if ((addr+p)>=0)
						addr+=n;
				}
				else if (addr<n)
					addr-=p;
			}
			p+=4;
		}
	}
}

inline uint get_hash(int p)
{
	return ((reinterpret_cast<uint&>(buf[p])&0xffffff) // Little-endian
		*2654435769UL)&~BUF_MASK;
}

inline int get_pts(int len, int x)
{
	return len>=MIN_MATCH
		?(len<<TAB_BITS)-x
		:((MIN_MATCH-1)<<TAB_BITS)-8;
}

int get_pts_at(int p, int n)
{
	const int c2=reinterpret_cast<ushort&>(buf[p-2]);
	const uint hash=get_hash(p);

	int len=MIN_MATCH-1;
	int idx=TAB_SIZE;

	int max_match=n-p;
	if (max_match>MAX_MATCH)
		max_match=MAX_MATCH;

	for (int x=0; x<TAB_SIZE; ++x)
	{
		const uint d=tab[c2][(cnt[c2]-x)&TAB_MASK];
		if (!d)
			break;

		if ((d&~BUF_MASK)!=hash)
			continue;

		const int s=d&BUF_MASK;
		if ((buf[s+len]!=buf[p+len])||(buf[s]!=buf[p]))
			continue;

		int l=0;
		while (++l<max_match)
			if (buf[s+l]!=buf[p+l])
				break;
		if (l>len)
		{
			idx=x;
			len=l;
			if (l==max_match)
				break;
		}
	}

	return get_pts(len, idx);
}

public:
Compressor(void *in_, void *out_, uint _BUF_BITS=25):
	BUF_BITS(_BUF_BITS), BUF_SIZE(1<<BUF_BITS), BUF_MASK(BUF_SIZE-1),
	buf(BUF_SIZE), tab(1<<16, std::vector<uint>(TAB_SIZE, 0)), cnt(1<<16),
	in(in_), out(out_), cm(in, out){}

int compress(bool max)
{
/*
	if (_fseeki64(in, 0, SEEK_END)!=0)
	{
		perror("Fseek failed");
		exit(1);
	}
	const long long flen=_ftelli64(in);
	if (flen<0)
	{
		perror("Ftell failed");
		exit(1);
	}
	rewind(in);

	putc(magic, out);
	fwrite(&flen, 1, sizeof(flen), out); // Little-endian
*/
	int best_idx[MAX_MATCH+1];

	int n;
	while ((n=read_enc(in, BUF_SIZE, buf.data()))>0)
	{
		cm.Put32(n);
		e8e9_transform<true>(n);

		//memset(tab, 0, sizeof(tab));
		for(auto &e: tab)std::fill(e.begin(), e.end(), 0);

		int p=0;

		while ((p<2)&&(p<n))
			cm.Encode(buf[p++], 0);

		while (p<n)
		{
			const int c2=reinterpret_cast<ushort&>(buf[p-2]);
			const uint hash=get_hash(p);

			int len=MIN_MATCH-1;
			int idx=TAB_SIZE;

			int max_match=n-p;
			if (max_match>MAX_MATCH)
				max_match=MAX_MATCH;

			for (int x=0; x<TAB_SIZE; ++x)
			{
				const uint d=tab[c2][(cnt[c2]-x)&TAB_MASK];
				if (!d)
					break;

				if ((d&~BUF_MASK)!=hash)
					continue;

				const int s=d&BUF_MASK;
				if ((buf[s+len]!=buf[p+len])||(buf[s]!=buf[p]))
					continue;

				int l=0;
				while (++l<max_match)
					if (buf[s+l]!=buf[p+l])
						break;
				if (l>len)
				{
					for (int i=l; i>len; --i)
						best_idx[i]=x;
					idx=x;
					len=l;
					if (l==max_match)
						break;
				}
			}

			if ((max)&&(len>=MIN_MATCH))
			{
				int sum=get_pts(len, idx)+get_pts_at(p+len, n);

				if (sum<get_pts(len+MAX_MATCH, 0))
				{
					const int lookahead=len;

					for (int i=1; i<lookahead; ++i)
					{
						const int tmp=get_pts(i, best_idx[i])+get_pts_at(p+i, n);
						if (tmp>sum)
						{
							sum=tmp;
							len=i;
						}
					}

					idx=best_idx[len];
				}
			}

			tab[c2][++cnt[c2]&TAB_MASK]=hash|p;

			if (len>=MIN_MATCH)
			{
				cm.Encode((256-MIN_MATCH)+len, buf[p-1]);
				cm.EncodeIdx(idx, buf[p-2]);
				p+=len;
			}
			else
			{
				cm.Encode(buf[p], buf[p-1]);
				++p;
			}
		}
	}

	cm.Put32(0);
	cm.Flush();
/*
	if (_ftelli64(in)!=flen)
	{
		fprintf(stderr, "Size mismatch\n");
		exit(1);
	}
	*/
	return 0;
}

int decompress()
{
/*
	if (getc(in)!=magic)
	{
		fprintf(stderr, "Not in BALZ format\n");
		exit(1);
	}
	
	long long flen;
	if ((fread(&flen, 1, sizeof(flen), in)!=sizeof(flen)) // Little-endian
		||(flen<0))
	{
		fprintf(stderr, "File corrupted\n");
		exit(1);
	}*/
	cm.Init();

	uint flen;
	while ((flen=cm.Get32())>0)
	{
		uint p=0;

		while ((p<2)&&(p<flen))
		{
			const int t=cm.Decode(0);
			if (t>=256)
			{
				//fprintf(stderr, "File corrupted\n");
				return -1;//exit(1);
			}
			buf[p++]=t;
		}

		while ((p<BUF_SIZE)&&(p<flen))
		{
			const int tmp=p;
			const int c2=reinterpret_cast<ushort&>(buf[p-2]);

			const int t=cm.Decode(buf[p-1]);
			if (t>=256)
			{
				int len=t-256;
				int s=tab[c2][(cnt[c2]-cm.DecodeIdx(buf[p-2]))&TAB_MASK];

				buf[p++]=buf[s++];
				buf[p++]=buf[s++];
				buf[p++]=buf[s++];
				while (len--)
					buf[p++]=buf[s++];
			}
			else
				buf[p++]=t;

			tab[c2][++cnt[c2]&TAB_MASK]=tmp;
		}

		e8e9_transform<false>(p);

		write_dec(out, p, buf.data());
	}
	return 0;
}
};

///

HRESULT CDecoder::CodeReal(ISequentialInStream *inStream, ISequentialOutStream *outStream,
    const UInt64* /* inSize */, const UInt64* /* outSize */, ICompressProgressInfo *progress)
{
  inS = inStream;
  outS.Create(1<<24);
  outS.Init();
  outS.SetStream(outStream);
  progr = progress;
  processedIn = processedOut = 0;
  int x = Compressor(this, this).decompress();
  outS.Flush();
  outS.Free();
  if(x<0)return E_FAIL;
  if(x==2)return E_ABORT;
  if(x==1)return E_OUTOFMEMORY;
  return x==0 ? S_OK : E_FAIL;
}


STDMETHODIMP CDecoder::Code(ISequentialInStream *inStream, ISequentialOutStream *outStream,
    const UInt64 *inSize, const UInt64 *outSize, ICompressProgressInfo *progress)
{
  try { return CodeReal(inStream, outStream, inSize, outSize, progress);  }
  catch(const CInBufferException &e)  { return e.ErrorCode; }
  catch(const CSystemException &e) { return e.ErrorCode; }
  catch(...) { return S_FALSE; }
}

STDMETHODIMP CDecoder::GetInStreamProcessedSize(UInt64 *value)
{
  *value = processedIn;
  return S_OK;
}

STDMETHODIMP CEncoder::SetCoderProperties(const PROPID * propIDs, const PROPVARIANT * coderProps, UInt32 numProps)
{
  for (UInt32 i = 0; i < numProps; i++){
	const PROPVARIANT & prop = coderProps[i];
	PROPID propID = propIDs[i];
	UInt32 v = (UInt32)prop.ulVal;
	switch (propID)
	{
	case NCoderPropID::kLevel:
	  {
		level = v;
	  }
	}
  }
  return S_OK;
}

HRESULT CEncoder::CodeReal(ISequentialInStream *inStream, ISequentialOutStream *outStream,
    const UInt64* /* inSize */, const UInt64* /* outSize */, ICompressProgressInfo *progress)
{
  inS = inStream;
  outS.Create(1<<24);
  outS.Init();
  outS.SetStream(outStream);
  progr = progress;
  processedIn = processedOut = 0;
  int x = Compressor(this, this).compress(level>=2);
  outS.Flush();
  outS.Free();
  if(x<0)return E_FAIL;
  if(x==2)return E_ABORT;
  if(x==1)return E_OUTOFMEMORY;
  return x==0 ? S_OK : E_FAIL;
}


STDMETHODIMP CEncoder::Code(ISequentialInStream *inStream, ISequentialOutStream *outStream,
    const UInt64 *inSize, const UInt64 *outSize, ICompressProgressInfo *progress)
{
  try { return CodeReal(inStream, outStream, inSize, outSize, progress);  }
  catch(const CInBufferException &e)  { return e.ErrorCode; }
  catch(const CSystemException &e) { return e.ErrorCode; }
  catch(...) { return S_FALSE; }
}

STDMETHODIMP CEncoder::GetInStreamProcessedSize(UInt64 *value)
{
  *value = processedIn;
  return S_OK;
}

///

static int write_dec(void *r_, size_t size, unsigned char *buf){
  CDecoder *r = (CDecoder*)r_;
  for(size_t i=0; i<size; i++){
  r->outS.WriteByte(buf[i]);
  r->processedOut += 1;
  if(r->processedOut%(1<<24)==0 && r->progr)
    r->progr->SetRatioInfo(&r->processedIn, &r->processedOut);
  }
  return size;
}
#if 0
static void putC_dec(unsigned char c, void *r_){
  CDecoder *r = (CDecoder*)r_;
  //UInt32 rlen=0;
  /*HRESULT res =*/ r->outS.WriteByte(c);
  r->processedOut += 1;
  if(r->processedOut%(1<<24)==0 && r->progr)
    r->progr->SetRatioInfo(&r->processedIn, &r->processedOut);
}
#endif
static int read_dec(void *r_, size_t size, void *buf){
  CDecoder *r = (CDecoder*)r_;
  size_t readsize = size;
  HRESULT res = ReadStream(r->inS,buf,&readsize);
  r->processedIn += readsize;
  return res != S_OK ? 0 : readsize;
}
static int getC_dec(void *r_){
  unsigned char buf[1];
  size_t readlen = read_dec(r_, 1, buf);
  if(readlen<1)return -1;
  return *buf;
}

static void putC_enc(unsigned char c, void *w_){
  CEncoder *w = (CEncoder*)w_;
  //UInt32 rlen=0;
  /*HRESULT res =*/ w->outS.WriteByte(c);
  w->processedOut += 1;
  if(w->processedOut%(1<<24)==0 && w->progr)
    w->progr->SetRatioInfo(&w->processedIn, &w->processedOut);
}
static int read_enc(void *w_, size_t size, void *buf){
  CEncoder *w = (CEncoder*)w_;
  size_t readsize = size;
  HRESULT res = ReadStream(w->inS,buf,&readsize);
  w->processedIn += readsize;
  return res != S_OK ? 0 : readsize;
}
#if 0
static int getC_enc(void *w_){
  unsigned char buf[1];
  size_t readlen = read_enc(w_, 1, buf);
  if(readlen<1)return -1;
  return *buf;
}
#endif

}}

#include "../../Common/RegisterCodec.h"

namespace NCompress {

REGISTER_CODEC_E(
  BALZ,
  NBALZ::CDecoder(),
  NBALZ::CEncoder(),
  0x04F7c102, "BALZ")

}
