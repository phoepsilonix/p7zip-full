// Md2Reg.cpp /TR 2018-11-02

#include "StdAfx.h"

#include "../../C/CpuArch.h"

EXTERN_C_BEGIN
#include "../../Codecs/hashes/md2.h"
EXTERN_C_END

#include "../Common/MyCom.h"
#include "../7zip/Common/RegisterCodec.h"

#include "../../C/7zVersion.h"
#if MY_VER_MAJOR >= 23
#define MY_UNKNOWN_IMP1 Z7_COM_UNKNOWN_IMP_1
#endif

// MD2
class CMD2Hasher:
  public IHasher,
  public CMyUnknownImp
{
  MD2_CTX _ctx;

public:
  CMD2Hasher() { MD2_Init(&_ctx); }

  MY_UNKNOWN_IMP1(IHasher)
#if MY_VER_MAJOR >= 23
  Z7_IFACE_COM7_IMP(IHasher)
#else
  INTERFACE_IHasher(;)
#endif

public:
  virtual ~CMD2Hasher() = default;
};

STDMETHODIMP_(void) CMD2Hasher::Init() throw()
{
  MD2_Init(&_ctx);
}

STDMETHODIMP_(void) CMD2Hasher::Update(const void *data, UInt32 size) throw()
{
  MD2_Update(&_ctx, (const Byte *)data, size);
}

STDMETHODIMP_(void) CMD2Hasher::Final(Byte *digest) throw()
{
  MD2_Final(digest, &_ctx);
}
REGISTER_HASHER(CMD2Hasher, 0x205, "MD2", MD2_DIGEST_LENGTH)
