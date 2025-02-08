// BalzEncoder.h

#ifndef __COMPRESS_BALZ_ENCODER_H
#define __COMPRESS_BALZ_ENCODER_H

#include "../../../Common/MyCom.h"

#include "../../ICoder.h"

#include "../../Common/InBuffer.h"
#include "../../Common/OutBuffer.h"

#include "../../../../C/7zVersion.h"
#if MY_VER_MAJOR >= 23
#define OVERRIDE override
#define MY_UNKNOWN_IMP1 Z7_COM_UNKNOWN_IMP_1
#define MY_UNKNOWN_IMP2 Z7_COM_UNKNOWN_IMP_2
#else
#define OVERRIDE
#endif

namespace NCompress {
namespace NBALZ {

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

public:
  STDMETHOD(Code)(ISequentialInStream *inStream, ISequentialOutStream *outStream,
      const UInt64 *inSize, const UInt64 *outSize, ICompressProgressInfo *progress) noexcept OVERRIDE;
  STDMETHOD (SetCoderProperties)(const PROPID *propIDs, const PROPVARIANT *props, UInt32 numProps) noexcept OVERRIDE;
  STDMETHOD(GetInStreamProcessedSize)(UInt64 *value) noexcept OVERRIDE;

  CEncoder(): level(1){}
  virtual ~CEncoder() = default;
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

public:
  STDMETHOD(Code)(ISequentialInStream *inStream, ISequentialOutStream *outStream,
      const UInt64 *inSize, const UInt64 *outSize, ICompressProgressInfo *progress) noexcept OVERRIDE;
  STDMETHOD(GetInStreamProcessedSize)(UInt64 *value) noexcept OVERRIDE;

  CDecoder(){}
  virtual ~CDecoder() = default;
};

}}

#endif
