// Md4Reg.cpp /TR 2018-11-02

#include "StdAfx.h"

#include "../../C/CpuArch.h"

EXTERN_C_BEGIN
#include "../../Codecs/hashes/md4.h"
EXTERN_C_END

#include "../Common/MyCom.h"
#include "../7zip/Common/RegisterCodec.h"

#include "../../C/7zVersion.h"
#if MY_VER_MAJOR >= 23
#define MY_UNKNOWN_IMP1 Z7_COM_UNKNOWN_IMP_1
#endif

// MD4
class CMD4Hasher:
  public IHasher,
  public CMyUnknownImp
{
  MD4_CTX _ctx;

public:
  CMD4Hasher() { MD4_Init(&_ctx); }

  MY_UNKNOWN_IMP1(IHasher)
#if MY_VER_MAJOR >= 23
  Z7_IFACE_COM7_IMP(IHasher)
#else
  INTERFACE_IHasher(;)
#endif

public:
  virtual ~CMD4Hasher() = default;
};

STDMETHODIMP_(void) CMD4Hasher::Init() throw()
{
  MD4_Init(&_ctx);
}

STDMETHODIMP_(void) CMD4Hasher::Update(const void *data, UInt32 size) throw()
{
  MD4_Update(&_ctx, (const Byte *)data, size);
}

STDMETHODIMP_(void) CMD4Hasher::Final(Byte *digest) throw()
{
  MD4_Final(digest, &_ctx);
}
REGISTER_HASHER(CMD4Hasher, 0x206, "MD4", MD4_DIGEST_LENGTH)
