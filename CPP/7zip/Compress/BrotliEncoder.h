// (C) 2017 Tino Reichardt

#define BROTLI_STATIC_LINKING_ONLY
#include "../../../C/Alloc.h"
#include "../../../C/Threads.h"
#include "brotli/encode.h"
#include "../../../Codecs/zstdmt/lib/brotli-mt.h"

#include "../../Common/Common.h"
#include "../../Common/MyCom.h"
#include "../ICoder.h"
#include "../Common/StreamUtils.h"

#include "../../../C/7zVersion.h"
#if MY_VER_MAJOR >= 23
#define OVERRIDE override
#define MY_QUERYINTERFACE_BEGIN2 Z7_COM_QI_BEGIN2
#define MY_QUERYINTERFACE_ENTRY Z7_COM_QI_ENTRY
#define MY_QUERYINTERFACE_END Z7_COM_QI_END
#define MY_ADDREF_RELEASE Z7_COM_ADDREF_RELEASE
#else
#define OVERRIDE
#endif

#ifndef EXTRACT_ONLY
namespace NCompress
{
  namespace NBROTLI
  {

    struct CProps
    {
      CProps() { clear(); }
      void clear()
      {
        memset(this, 0, sizeof(*this));
        _ver_major = BROTLI_VERSION_MAJOR;
        _ver_minor = BROTLI_VERSION_MINOR;
        _level = 3;
      }

      Byte _ver_major;
      Byte _ver_minor;
      Byte _level;
    };

    class CEncoder : public ICompressCoder,
                     public ICompressSetCoderMt,
                     public ICompressSetCoderProperties,
                     public ICompressWriteCoderProperties,
                     public CMyUnknownImp
    {
      CProps _props;

      UInt64 _processedIn;
      UInt64 _processedOut;
      UInt32 _inputSize;
      UInt32 _numThreads;

      BROTLIMT_CCtx *_ctx;

    public:
      MY_QUERYINTERFACE_BEGIN2(ICompressCoder)
      MY_QUERYINTERFACE_ENTRY(ICompressSetCoderMt)
      MY_QUERYINTERFACE_ENTRY(ICompressSetCoderProperties)
      MY_QUERYINTERFACE_ENTRY(ICompressWriteCoderProperties)
      MY_QUERYINTERFACE_END
      MY_ADDREF_RELEASE

    public:
      STDMETHOD(Code)
      (ISequentialInStream *inStream, ISequentialOutStream *outStream, const UInt64 *inSize, const UInt64 *outSize, ICompressProgressInfo *progress) noexcept OVERRIDE;
      STDMETHOD(SetCoderProperties)
      (const PROPID *propIDs, const PROPVARIANT *props, UInt32 numProps) noexcept OVERRIDE;
      STDMETHOD(WriteCoderProperties)
      (ISequentialOutStream *outStream) noexcept OVERRIDE;
      STDMETHOD(SetNumberOfThreads)
      (UInt32 numThreads) noexcept OVERRIDE;

      CEncoder();
      virtual ~CEncoder();
    };

  }
}
#endif
