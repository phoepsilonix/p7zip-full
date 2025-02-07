// Sha512Reg.cpp /TR 2018-11-02

#include "StdAfx.h"

#include "../../C/CpuArch.h"

EXTERN_C_BEGIN
#include "../../Codecs/hashes/sha.h"
EXTERN_C_END

#include "../Common/MyCom.h"
#include "../7zip/Common/RegisterCodec.h"

#include "../../C/7zVersion.h"
#if MY_VER_MAJOR >= 23
#define MY_UNKNOWN_IMP1 Z7_COM_UNKNOWN_IMP_1
#endif

// SHA512
class CSHA512Hasher:
  public IHasher,
  public CMyUnknownImp
{
  SHA512_CTX _ctx;
  Byte mtDummy[1 << 7];

public:
  CSHA512Hasher() { SHA512_Init(&_ctx); }

  MY_UNKNOWN_IMP1(IHasher)
#if MY_VER_MAJOR >= 23
  Z7_IFACE_COM7_IMP(IHasher)
#else
  INTERFACE_IHasher(noexcept;)
#endif

public:
  virtual ~CSHA512Hasher() = default;
};

STDMETHODIMP_(void) CSHA512Hasher::Init() throw()
{
  SHA512_Init(&_ctx);
}

STDMETHODIMP_(void) CSHA512Hasher::Update(const void *data, UInt32 size) throw()
{
  SHA512_Update(&_ctx, (const Byte *)data, size);
}

STDMETHODIMP_(void) CSHA512Hasher::Final(Byte *digest) throw()
{
  SHA512_Final(digest, &_ctx);
}
REGISTER_HASHER(CSHA512Hasher, 0x209, "SHA512", SHA512_DIGEST_LENGTH)
