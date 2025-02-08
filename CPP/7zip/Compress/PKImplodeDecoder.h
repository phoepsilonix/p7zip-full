// ImplodeDecoder.h

#ifndef __COMPRESS_PKIMPLODE_DECODER_H
#define __COMPRESS_PKIMPLODE_DECODER_H

#include "../../Common/MyCom.h"

#include "../ICoder.h"

#include "../Common/InBuffer.h"

extern "C" {
#include "../../../Codecs/StormLib/src/pklib/pklib.h"
}

#include "../../../C/7zVersion.h"
#if MY_VER_MAJOR >= 23
#define OVERRIDE override
#define MY_UNKNOWN_IMP1 Z7_COM_UNKNOWN_IMP_1
#else
#define OVERRIDE
#endif

namespace NCompress {
namespace NPKImplode {
namespace NDecoder {

static const unsigned int kS = 65536;

class CDecoder:
  public ICompressCoder,
  public ICompressGetInStreamProcessedSize,
  public CMyUnknownImp
{
  HRESULT CodeReal(ISequentialInStream *inStream, ISequentialOutStream *outStream,
      const UInt64 *inSize, const UInt64 *outSize, ICompressProgressInfo *progress);

public:
  unsigned char buf[kS];
  UInt64 processedIn;
  UInt64 processedOut;
  ISequentialInStream *inS;
  ISequentialOutStream *outS;
  ICompressProgressInfo *progr;

  TDcmpStruct DcmpStruct;

  MY_UNKNOWN_IMP1(ICompressGetInStreamProcessedSize)

public:
  STDMETHOD(Code)(ISequentialInStream *inStream, ISequentialOutStream *outStream,
      const UInt64 *inSize, const UInt64 *outSize, ICompressProgressInfo *progress) noexcept OVERRIDE;
  STDMETHOD(GetInStreamProcessedSize)(UInt64 *value) noexcept OVERRIDE;

  CDecoder();
  virtual ~CDecoder() = default;
};

}}}

#endif
