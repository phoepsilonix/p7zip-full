// (C) 2016 - 2018 Tino Reichardt

#define ZSTD_STATIC_LINKING_ONLY
#include "../../../C/Alloc.h"
#include "../../../Codecs/zstd/lib/zstd_errors.h"
#include "../../../Codecs/zstd/lib/zstd.h"

#include "../../Common/Common.h"
#include "../../Common/MyCom.h"
#include "../../Windows/System.h"
#include "../Common/ProgressMt.h"
#include "../Common/RegisterCodec.h"
#include "../Common/StreamUtils.h"
#include "../ICoder.h"

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

/**
 * possible return values @ 7zip:
 * S_OK / S_FALSE
 * E_NOTIMPL
 * E_NOINTERFACE
 * E_ABORT
 * E_FAIL
 * E_OUTOFMEMORY
 * E_INVALIDARG
 */

#define ZSTD_LEVEL_MIN 1
#define ZSTD_LEVEL_MAX 22
#define ZSTD_THREAD_MAX 256

namespace NCompress {
namespace NZSTD {

struct DProps {
  DProps() { clear(); }
  void clear() {
    memset(this, 0, sizeof(*this));
    _ver_major = ZSTD_VERSION_MAJOR;
    _ver_minor = ZSTD_VERSION_MINOR;
    _level = 3;
  }

  Byte _ver_major;
  Byte _ver_minor;
  Byte _level;
  Byte _reserved[2];
};

class CDecoder : public ICompressCoder,
                 public ICompressSetDecoderProperties2,
                 public ICompressSetOutStreamSize,
                 #ifndef NO_READ_FROM_CODER
                 public ICompressSetInStream,
                 #endif
                 public ICompressSetCoderMt,
                 public CMyUnknownImp {
  CMyComPtr<ISequentialInStream> _inStream;
  DProps _props;

  ZSTD_DCtx *_ctx;
  void *_srcBuf;
  void *_dstBuf;
  size_t _srcBufSize;
  size_t _dstBufSize;

  UInt64 _processedIn;
  UInt64 _processedOut;

  HRESULT CodeSpec(ISequentialInStream *inStream,
                   ISequentialOutStream *outStream,
                   ICompressProgressInfo *progress);
  HRESULT SetOutStreamSizeResume(const UInt64 *outSize);

public:
  MY_QUERYINTERFACE_BEGIN2(ICompressCoder)
  MY_QUERYINTERFACE_ENTRY(ICompressSetDecoderProperties2)
#ifndef NO_READ_FROM_CODER
  MY_QUERYINTERFACE_ENTRY(ICompressSetInStream)
#endif
  MY_QUERYINTERFACE_ENTRY(ICompressSetCoderMt)
  MY_QUERYINTERFACE_END
  MY_ADDREF_RELEASE

public:
  STDMETHOD(Code)
  (ISequentialInStream *inStream, ISequentialOutStream *outStream,
   const UInt64 *inSize, const UInt64 *outSize,
   ICompressProgressInfo *progress) noexcept OVERRIDE;
  STDMETHOD(SetDecoderProperties2)(const Byte *data, UInt32 size) noexcept OVERRIDE;
  STDMETHOD(SetOutStreamSize)(const UInt64 *outSize) noexcept OVERRIDE;
  STDMETHOD(SetNumberOfThreads)(UInt32 numThreads) noexcept OVERRIDE;

#ifndef NO_READ_FROM_CODER
  STDMETHOD(SetInStream)(ISequentialInStream *inStream) noexcept OVERRIDE;
  STDMETHOD(ReleaseInStream)() noexcept OVERRIDE;
  UInt64 GetInputProcessedSize() const { return _processedIn; }
#endif
  HRESULT CodeResume(ISequentialOutStream *outStream, const UInt64 *outSize,
                     ICompressProgressInfo *progress);

  CDecoder();
  virtual ~CDecoder();
};

} // namespace NZSTD
} // namespace NCompress
