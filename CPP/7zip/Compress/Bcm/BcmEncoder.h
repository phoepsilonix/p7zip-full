// BcmEncoder.h

#ifndef __COMPRESS_BCM_ENCODER_H
#define __COMPRESS_BCM_ENCODER_H

#include "../../../Common/MyCom.h"

#include "../../ICoder.h"

#include "../../Common/InBuffer.h"
#include "../../Common/OutBuffer.h"

namespace NCompress {
namespace NBCM {

class CEncoder:
  public ICompressCoder,
  public ICompressGetInStreamProcessedSize,
  public ICompressSetCoderProperties,
  public CMyUnknownImp
{
  HRESULT CodeReal(ISequentialInStream *inStream, ISequentialOutStream *outStream,
      const UInt64 *inSize, const UInt64 *outSize, ICompressProgressInfo *progress);

public:
  UInt64 processedIn;
  UInt64 processedOut;
  ISequentialInStream *inS;
  //ISequentialOutStream *outS;
  COutBuffer outS;
  ICompressProgressInfo *progr;

  unsigned int level;

  MY_UNKNOWN_IMP2(ICompressGetInStreamProcessedSize, ICompressSetCoderProperties)

  STDMETHOD(Code)(ISequentialInStream *inStream, ISequentialOutStream *outStream,
      const UInt64 *inSize, const UInt64 *outSize, ICompressProgressInfo *progress);
  STDMETHOD (SetCoderProperties)(const PROPID *propIDs, const PROPVARIANT *props, UInt32 numProps);
  STDMETHOD(GetInStreamProcessedSize)(UInt64 *value);

  CEncoder(): level(4){}
};

class CDecoder:
  public ICompressCoder,
  public ICompressGetInStreamProcessedSize,
  public CMyUnknownImp
{
  HRESULT CodeReal(ISequentialInStream *inStream, ISequentialOutStream *outStream,
      const UInt64 *inSize, const UInt64 *outSize, ICompressProgressInfo *progress);

public:
  UInt64 processedIn;
  UInt64 processedOut;
  ISequentialInStream *inS;
  //ISequentialOutStream *outS;
  COutBuffer outS;
  ICompressProgressInfo *progr;

  MY_UNKNOWN_IMP1(ICompressGetInStreamProcessedSize)

  STDMETHOD(Code)(ISequentialInStream *inStream, ISequentialOutStream *outStream,
      const UInt64 *inSize, const UInt64 *outSize, ICompressProgressInfo *progress);
  STDMETHOD(GetInStreamProcessedSize)(UInt64 *value);

  CDecoder(){}
};

}}

#endif
