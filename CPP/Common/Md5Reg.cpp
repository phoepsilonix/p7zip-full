// Md5Reg.cpp /TR 2018-11-02

#include "StdAfx.h"

#include "../../C/CpuArch.h"

EXTERN_C_BEGIN
#include "../../Codecs/hashes/md5.h"
EXTERN_C_END

#include "../Common/MyCom.h"
#include "../7zip/Common/RegisterCodec.h"

#include "../../C/7zVersion.h"
#if MY_VER_MAJOR >= 23
#define MY_UNKNOWN_IMP1 Z7_COM_UNKNOWN_IMP_1
#endif

// MD5
class CMD5Hasher:
  public IHasher,
  public CMyUnknownImp
{
  MD5_CTX _ctx;
  Byte mtDummy[1 << 7];

public:
  CMD5Hasher() { MD5_Init(&_ctx); }

  MY_UNKNOWN_IMP1(IHasher)
#if MY_VER_MAJOR >= 23
  Z7_IFACE_COM7_IMP(IHasher)
#else
  INTERFACE_IHasher(;)
#endif

public:
  virtual ~CMD5Hasher() = default;
};

STDMETHODIMP_(void) CMD5Hasher::Init() throw()
{
  MD5_Init(&_ctx);
}

STDMETHODIMP_(void) CMD5Hasher::Update(const void *data, UInt32 size) throw()
{
  MD5_Update(&_ctx, (const Byte *)data, size);
}

STDMETHODIMP_(void) CMD5Hasher::Final(Byte *digest) throw()
{
  MD5_Final(digest, &_ctx);
}
REGISTER_HASHER(CMD5Hasher, 0x207, "MD5", MD5_DIGEST_LENGTH)
