// (C) 2016 Tino Reichardt

#define LZ5_STATIC_LINKING_ONLY
#include "../../../C/Alloc.h"
#include "../../../C/Threads.h"
#include "../../../Codecs/lz5/lib/lz5.h"
#include "../../../Codecs/zstdmt/lib/lz5-mt.h"

#include "../../Common/Common.h"
#include "../../Common/MyCom.h"
#include "../ICoder.h"
#include "../Common/StreamUtils.h"

#include "../../../C/7zVersion.h"
#if MY_VER_MAJOR >= 23
#define MY_QUERYINTERFACE_BEGIN2 Z7_COM_QI_BEGIN2
#define MY_QUERYINTERFACE_ENTRY Z7_COM_QI_ENTRY
#define MY_QUERYINTERFACE_END Z7_COM_QI_END
#define MY_ADDREF_RELEASE Z7_COM_ADDREF_RELEASE
#endif

#ifndef EXTRACT_ONLY
namespace NCompress
{
  namespace NLZ5
  {

    struct CProps
    {
      CProps() { clear(); }
      void clear()
      {
        memset(this, 0, sizeof(*this));
        _ver_major = LZ5_VERSION_MAJOR;
        _ver_minor = LZ5_VERSION_MINOR;
        _level = 3;
      }

      Byte _ver_major;
      Byte _ver_minor;
      Byte _level;
      Byte _reserved[2];
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

      LZ5MT_CCtx *_ctx;

    public:
      MY_QUERYINTERFACE_BEGIN2(ICompressCoder)
      MY_QUERYINTERFACE_ENTRY(ICompressSetCoderMt)
      MY_QUERYINTERFACE_ENTRY(ICompressSetCoderProperties)
      MY_QUERYINTERFACE_ENTRY(ICompressWriteCoderProperties)
      MY_QUERYINTERFACE_END
      MY_ADDREF_RELEASE

    public:
      STDMETHOD(Code)
      (ISequentialInStream *inStream, ISequentialOutStream *outStream, const UInt64 *inSize, const UInt64 *outSize, ICompressProgressInfo *progress) noexcept;
      STDMETHOD(SetCoderProperties)
      (const PROPID *propIDs, const PROPVARIANT *props, UInt32 numProps) noexcept;
      STDMETHOD(WriteCoderProperties)
      (ISequentialOutStream *outStream) noexcept;
      STDMETHOD(SetNumberOfThreads)
      (UInt32 numThreads) noexcept;

      CEncoder();
      virtual ~CEncoder();
    };

  }
}
#endif
