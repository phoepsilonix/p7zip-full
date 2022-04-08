// BcmRegister.cpp

#include "StdAfx.h"

#include "BcmEncoder.h"
#include "../../Common/StreamUtils.h"

/*

BCM - A BWT-based file compressor

Copyright (C) 2008-2021 Ilya Muravyov

*/

#include "libsais.h"
#include <stdlib.h>

typedef unsigned char U8;
typedef unsigned short U16;
typedef unsigned int U32;
typedef unsigned long long U64;
typedef signed long long S64;

// Globals

namespace NCompress {
namespace NBCM {

//const char magic[]="BCM!";

//FILE* in;
//FILE* out;

static void putC_enc(unsigned char c, void *w_);
static int read_enc(void *w_, size_t size, void *buf);
//static int getC_enc(void *w_);
static void putC_dec(unsigned char c, void *r_);
static int read_dec(void *r_, size_t size, void *buf);
static int getC_dec(void *r_);

struct Encoder
{
  U32 low;
  U32 high;
  U32 code;
  void *in;
  void *out;

  Encoder(void *in_, void *out_): in(in_), out(out_)
  {
    low=0;
    high=U32(-1);
    code=0;
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
      code=(code<<8)+getC_dec(in);
  }

  template<int P_LOG>
  void EncodeBit(int bit, U32 p)
  {
    const U32 mid=low+((U64(high-low)*p)>>P_LOG);

    if (bit)
      high=mid;
    else
      low=mid+1;

    // Renormalize
    while ((low^high)<(1<<24))
    {
      putC_enc(low>>24, out);
      low<<=8;
      high=(high<<8)+255;
    }
  }

  template<int P_LOG>
  int DecodeBit(U32 p)
  {
    const U32 mid=low+((U64(high-low)*p)>>P_LOG);

    const int bit=(code<=mid);
    if (bit)
      high=mid;
    else
      low=mid+1;

    // Renormalize
    while ((low^high)<(1<<24))
    {
      low<<=8;
      high=(high<<8)+255;
      code=(code<<8)+getC_dec(in);
    }

    return bit;
  }
};

template<int RATE>
struct Counter
{
  U16 p;

  Counter()
  {
    p=1<<15; // 0.5
  }

  void Update1()
  {
    p+=(p^0xFFFF)>>RATE;
  }

  void Update0()
  {
    p-=p>>RATE;
  }
};

struct CM: Encoder
{
  Counter<2> counter0[256];
  Counter<4> counter1[256][256];
  Counter<6> counter2[2][256][17];
  int run;
  int c1;
  int c2;

  CM(void *in_, void *out_): Encoder(in_, out_)
  {
    run=0;
    c1=0;
    c2=0;

    for (int i=0; i<2; ++i)
    {
      for (int j=0; j<256; ++j)
      {
        for (int k=0; k<=16; ++k)
          counter2[i][j][k].p=(k<<12)-(k==16);
      }
    }
  }

  void Put32(U32 x)
  {
    for (U32 i=1<<31; i>0; i>>=1)
      EncodeBit<1>(x&i, 1); // p=0.5
  }

  U32 Get32()
  {
    U32 x=0;
    for (int i=0; i<32; ++i)
      x+=x+DecodeBit<1>(1); // p=0.5

    return x;
  }

  void Put(int c)
  {
    const int f=(run>2);

    int ctx=1;
    for (int i=128; i>0; i>>=1)
    {
      const int p0=counter0[ctx].p;
      const int p1=counter1[c1][ctx].p;
      const int p2=counter1[c2][ctx].p;
      const int p=(((p0+p1)*7)+p2+p2)>>4;

      // SSE with linear interpolation
      const int j=p>>12;
      const int x1=counter2[f][ctx][j].p;
      const int x2=counter2[f][ctx][j+1].p;
      const int ssep=x1+(((x2-x1)*(p&4095))>>12);

      if (c&i)
      {
        EncodeBit<18>(1, p+ssep+ssep+ssep);

        counter0[ctx].Update1();
        counter1[c1][ctx].Update1();
        counter2[f][ctx][j].Update1();
        counter2[f][ctx][j+1].Update1();

        ctx+=ctx+1;
      }
      else
      {
        EncodeBit<18>(0, p+ssep+ssep+ssep);

        counter0[ctx].Update0();
        counter1[c1][ctx].Update0();
        counter2[f][ctx][j].Update0();
        counter2[f][ctx][j+1].Update0();

        ctx+=ctx;
      }
    }

    c2=c1;
    c1=ctx-256;

    if (c1==c2)
      ++run;
    else
      run=0;
  }

  int Get()
  {
    const int f=(run>2);

    int ctx=1;
    while (ctx<256)
    {
      const int p0=counter0[ctx].p;
      const int p1=counter1[c1][ctx].p;
      const int p2=counter1[c2][ctx].p;
      const int p=(((p0+p1)*7)+p2+p2)>>4;

      // SSE with linear interpolation
      const int j=p>>12;
      const int x1=counter2[f][ctx][j].p;
      const int x2=counter2[f][ctx][j+1].p;
      const int ssep=x1+(((x2-x1)*(p&4095))>>12);

      if (DecodeBit<18>(p+ssep+ssep+ssep))
      {
        counter0[ctx].Update1();
        counter1[c1][ctx].Update1();
        counter2[f][ctx][j].Update1();
        counter2[f][ctx][j+1].Update1();

        ctx+=ctx+1;
      }
      else
      {
        counter0[ctx].Update0();
        counter1[c1][ctx].Update0();
        counter2[f][ctx][j].Update0();
        counter2[f][ctx][j+1].Update0();

        ctx+=ctx;
      }
    }

    c2=c1;
    c1=ctx-256;

    if (c1==c2)
      ++run;
    else
      run=0;

    return c1;
  }
};

template<typename T>
inline T* MemAlloc(size_t n)
{
  T* p=(T*)malloc(n*sizeof(T));
  if (!p)
  {
    //perror("Malloc() failed");
    //exit(1);
  }
  return p;
}

int Compress(void *in, void *out, int level)
{
  CM cm(in, out);
  const int tab[11]=
  {
    0,
    1<<20,      // -1 - 1 MB
    1<<22,      // -2 - 4 MB
    1<<23,      // -3 - 8 MB
    1<<24,      // -4 - 16 MB (Default)
    1<<25,      // -5 - 32 MB
    1<<26,      // -6 - 64 MB
    1<<27,      // -7 - 128 MB
    1<<28,      // -8 - 256 MB
    1<<29,      // -9 - 512 MB
    0x7FFFFFFF, // -10 - ~2 GB
  };
  int bsize=tab[level]; // Block size

#if 0
  if (_fseeki64(in, 0, SEEK_END))
  {
    perror("Fseek() failed");
    exit(1);
  }
  const S64 flen=_ftelli64(in);
  if (flen<0)
  {
    perror("Ftell() failed");
    exit(1);
  }
  rewind(in);

  if (bsize>flen)
    bsize=int(flen);
#endif

  U8* buf=MemAlloc<U8>(bsize);
  int* ptr=MemAlloc<int>(bsize);

  int n;
  while ((n=read_enc(in, bsize, buf))>0)
  {
    //crc.Update(buf, n);

    const int idx=libsais_bwt(buf, buf, ptr, n);
    if (idx<1)
    {
      //fprintf(stderr, "BWT() failed: idx = %d\n", idx);
      //exit(1);
      free(buf);
      free(ptr);
      return -1;
    }

    cm.Put32(n); // Block size
    cm.Put32(idx); // BWT index

    for (int i=0; i<n; ++i)
      cm.Put(buf[i]);

    //fprintf(stderr, "%lld -> %lld\r", _ftelli64(in), _ftelli64(out));
  }

  cm.Put32(0); // EOF
  //cm.Put32(crc()); // CRC32

  cm.Flush();

  free(buf);
  free(ptr);
  return 0;
}

int Decompress(void *in, void *out)
{
  int cnt[257];

  int bsize=0;
  U8* buf=nullptr;
  U32* ptr=nullptr;

  CM cm(in, out);
  cm.Init();

  int n;
  while ((n=cm.Get32())>0)
  {
    if (!bsize)
    {
      if ((bsize=n)>=(1<<24)) // 5*N
        buf=MemAlloc<U8>(bsize);
      ptr=MemAlloc<U32>(bsize);
    }

    const int idx=cm.Get32();
    if (n>bsize || idx<1 || idx>n)
    {
      //fprintf(stderr, "Corrupt input!\n");
      if(buf)free(buf);
      free(ptr);
      //exit(1);
      return -1;
    }

    // Inverse BW-transform

    if (n>=(1<<24)) // 5*N
    {
      memset(cnt, 0, sizeof(cnt));
      for (int i=0; i<n; ++i)
        ++cnt[(buf[i]=cm.Get())+1];
      for (int i=1; i<256; ++i)
        cnt[i]+=cnt[i-1];

      for (int i=0; i<idx; ++i)
        ptr[cnt[buf[i]]++]=i;
      for (int i=idx+1; i<=n; ++i)
        ptr[cnt[buf[i-1]]++]=i;

      int p=idx;
      for (int i=0; i<n; ++i)
      {
        p=ptr[p-1];
        const int c=buf[p-(p>=idx)];
        //crc.Update(c);
        putC_dec(c, out);
      }
    }
    else // 4*N
    {
      memset(cnt, 0, sizeof(cnt));
      for (int i=0; i<n; ++i)
        ++cnt[(ptr[i]=cm.Get())+1];
      for (int i=1; i<256; ++i)
        cnt[i]+=cnt[i-1];

      for (int i=0; i<idx; ++i)
        ptr[cnt[ptr[i]&255]++]|=i<<8;
      for (int i=idx+1; i<=n; ++i)
        ptr[cnt[ptr[i-1]&255]++]|=i<<8;

      int p=idx;
      for (int i=0; i<n; ++i)
      {
        p=ptr[p-1]>>8;
        const int c=ptr[p-(p>=idx)];
        //crc.Update(c);
        putC_dec(c, out);
      }
    }

    //fprintf(stderr, "%lld -> %lld\r", _ftelli64(in), _ftelli64(out));
  }

  //if (cm.Get32()!=crc())
  //{
  //  fprintf(stderr, "CRC error!\n");
  //  exit(1);
  //}

  if (buf)
    free(buf);
  free(ptr);
  return 0;
}

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
  int x = Decompress(this, this);
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
  int x = Compress(this, this, level);
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

static void putC_dec(unsigned char c, void *r_){
  CDecoder *r = (CDecoder*)r_;
  //UInt32 rlen=0;
  /*HRESULT res =*/ r->outS.WriteByte(c);
  r->processedOut += 1;
  if(r->processedOut%(1<<24)==0 && r->progr)
    r->progr->SetRatioInfo(&r->processedIn, &r->processedOut);
}
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
  BCM,
  NBCM::CDecoder(),
  NBCM::CEncoder(),
  0x04F7c101, "BCM")

}
