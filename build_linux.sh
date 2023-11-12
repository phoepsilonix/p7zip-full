#!/bin/bash
set -e

MPL=${CMPL:-cmpl_gcc_x64}
OUTDIR=${OUTDIR:-g_x64}

export unset LDFLAGS
export unset CPPFLAGS
export unset CFLAGS
export unset CXXFLAGS
#CPPFLAGS="-Wp,-D_FORTIFY_SOURCE=2 -D_FORTIFY_SOURCE=2"
#if [[ $CC == "clang" ]];then
#export CFLAGS_ADD="$CPPFLAGS -pipe -fno-plt -fexceptions -Wformat -Werror=format-security -Wtautological-compare -ffunction-sections -fdata-sections -U_FORTIFY_SOURCE -ftrapv -Wformat-security -fcf-protection=full"
#export LDFLAGS_ADD="-fuse-ld=lld -Wl,-z,relro,-z,now,-z,notext -mguard=cf -Wl,-z,noexecstack"

#export CFLAGS_ADD="$CPPFLAGS -pipe -fno-plt -fexceptions -Wp,-D_FORTIFY_SOURCE=2 -D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -Wtautological-compare -Wsign-compare -gfull -fstandalone-debug -gdwarf-5 -gz -fPIC -fforce-emit-vtables -ffunction-sections -fdata-sections -fintegrated-as -fintegrated-cc1 -U_FORTIFY_SOURCE"
#export LDFLAGS_ADD="-fuse-ld=lld -fPIE -fpie -Wl,--gc-sections -fno-plt -Wl,-z,relro,-z,now -Wl,-z,notext -mguard=cf -Wl,--no-undefined -Wl,-z,noexecstack"
export LD=ld.lld
#else
#CFLAGS_ADD="$CPPFLAGS -march=x86-64 -mtune=generic -O2 -pipe -fno-plt -fexceptions -Wformat -Werror=format-security -Wtautological-compare -g -gdwarf-5 -gz -fPIC -fPIE -fpie -ffunction-sections -fdata-sections -fcf-protection -fstack-protector-all -fstack-clash-protection -fno-sanitize-recover=all -U_FORTIFY_SOURCE -fstack-protector -ftrapv -Wformat-security -fcf-protection=full -flto=auto"
#LDFLAGS_ADD="-fuse-ld=lld -fPIC -fPIE -pie -Wl,-z,noexecstack -fno-plt -Wl,--gc-sections,-z,relro,-z,now,-z,combreloc,-z,notext -flto=auto -fuse-linker-plugin -ffat-lto-objects"
#fi
#export CFLAGS_ADD="-Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter"
export CFLAGS_ADD="-Wno-error=unused-const-variable -Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter -Wno-error=unused-command-line-argument"

mkdir -p bin/Codecs

# zig cc clang musl
#source ./zig-build.sh

export MUSL_CC="clang"
export MUSL_CC_TARGET=""
export MUSL_CXX="clang++"
export MUSL_CXX_TARGET=""
export MUSL_CC_NOPIE="clang-no-pie"
export MUSL_CXX_NOPIE="clang++-no-pie"
export GNU_CC="clang"
export GNU_CXX="clang++"
export GNU_CC_PIE="gnuc-pie"
export GNU_CXX_PIE="gnuc++-pie"
export GNU_CC_NOPIE="gnuc-no-pie"
export GNU_CXX_NOPIE="gnuc++-no-pie"
export ASM="$MUSL_CC"
export MAKE=make

export LDFLAGS_ADD="-fuse-ld=lld -Wl,--gc-sections -fno-plt -Wl,-z,relro,-z,now -Wl,-z,notext -Wno-error=unused-command-line-argument"

# dynamic link
export CC="$MUSL_CC $MUSL_CC_TARGET"
export CXX="$MUSL_CXX $MUSL_CXX_TARGET"
export CODEC_CC="$MUSL_CC $MUSL_CC_TARGET"
export CODEC_CXX="$MUSL_CXX $MUSL_CXX_TARGET"
export CODEC_CC_NOPIE="$MUSL_CC"
export CODEC_CXX_NOPIE="$MUSL_CXX"
export CODEC_C_TARGET="$MUSL_C_TARGET"
export CODEC_CXX_TARGET="$MUSL_CXX_TARGET"
export CFLAGS_ADD="-Wno-error=unused-const-variable -Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter -Wno-error=unused-command-line-argument"
export LDFLAGS_ADD="-fuse-ld=lld -Wl,-z,relro,-z,now -Wno-error=unused-command-line-argument"
make -C CPP/7zip/UI/Console -f makefile.gcc mkdir && make -C CPP/7zip/UI/Console -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/UI/Console/_o/7z bin/
make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j16
cp CPP/7zip/Bundles/Format7zF/_o/7z.so bin/
make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j16
cp CPP/7zip/Bundles/Alone2/_o/7zz bin/

# shared library
export CC="$GNU_CC"
export CXX="$GNU_CXX"
export CODEC_CC="$GNU_CC"
export CODEC_CXX="$GNU_CXX"
export CFLAGS_ADD="-Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter"

#
#export CFLAGS_ADD="$CPPFLAGS -pipe -fno-plt -fexceptions -Wp,-D_FORTIFY_SOURCE=2 -D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -Wtautological-compare -Wsign-compare -gfull -fstandalone-debug -gdwarf-5 -gz -fforce-emit-vtables -ffunction-sections -fdata-sections -fintegrated-as -fintegrated-cc1 -U_FORTIFY_SOURCE"
#export CFLAGS_ADD="$CFLAGS_ADD -Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter"
#export LDFLAGS_ADD="-fuse-ld=lld -Wl,--gc-sections -fno-plt -Wl,-z,relro,-z,now -Wl,-z,notext -Wl,--no-undefined -Wl,-z,noexecstack"
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Bundles/SFXCon/_o/7zCon.sfx bin/

make -C C/Util/Lzma -f makefile.gcc mkdir && make -C C/Util/Lzma -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp C/Util/Lzma/_o/7lzma bin/
make -C CPP/7zip/UI/Client7z -f makefile.gcc mkdir && make -C CPP/7zip/UI/Client7z -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/UI/Client7z/_o/7zcl bin/
make -C C/Util/7z -f makefile.gcc mkdir && make -C C/Util/7z -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp C/Util/7z/_o/7zdec bin/

# shared object
# dynamic link
export CC="$GNU_CC"
export CXX="$GNU_CXX"
export CODEC_CC="$GNU_CC"
export CODEC_CXX="$GNU_CC"
export LDFLAGS_ADD="-fuse-ld=lld -Wl,--gc-sections -fno-plt -Wl,-z,relro,-z,now -Wl,-z,notext"
make -C CPP/7zip/Compress/Rar -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Rar -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Rar/_o/Rar.so bin/Codecs/
make -C CPP/7zip/Compress/Zstd -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Zstd -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Zstd/_o/Zstd.so bin/Codecs/
make -C CPP/7zip/Compress/Lz4 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lz4 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Lz4/_o/Lz4.so bin/Codecs/
make -C CPP/7zip/Compress/Lz5 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lz5 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Lz5/_o/Lz5.so bin/Codecs/
make -C CPP/7zip/Compress/Lizard -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lizard -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Lizard/_o/Lizard.so bin/Codecs/
make -C CPP/7zip/Compress/Brotli -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Brotli -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Brotli/_o/Brotli.so bin/Codecs/
make -C CPP/7zip/Compress/FLzma2 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/FLzma2 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/FLzma2/_o/FLzma2.so bin/Codecs/

export CC="$GNU_CC"
export CXX="$GNU_CXX"
export CODEC_CC="$GNU_CC"
export CODEC_CXX="$GNU_CXX"
#export LDFLAGS_ADD="-fuse-ld=lld -Wl,--gc-sections -fno-plt -Wl,-z,relro,-z,now -Wl,-z,notext"
make -C CPP/7zip/Compress/Lzham -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lzham -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Lzham/_o/Lzham.so bin/Codecs/

export CC="$GNU_CC"
export CXX="$GNU_CXX"
export CODEC_CC="$GNU_CC"
export CODEC_CXX="$GNU_CC"
#export LDFLAGS_ADD="-fuse-ld=lld -Wl,--gc-sections -fno-plt -Wl,-z,relro,-z,now -Wl,-z,notext"
make -C CPP/7zip/Compress/PKImplode -f makefile.gcc mkdir && make -C CPP/7zip/Compress/PKImplode -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/PKImplode/_o/PKImplode.so bin/Codecs/
make -C CPP/7zip/Compress/Bcm -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Bcm -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Bcm/_o/Bcm.so bin/Codecs/
make -C CPP/7zip/Compress/Balz -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Balz -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Balz/_o/Balz.so bin/Codecs/
make -C CPP/7zip/Compress/Md5 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Md5 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Md5/_o/Md5.so bin/Codecs/
make -C CPP/7zip/Compress/Sha512 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Sha512 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Sha512/_o/Sha512.so bin/Codecs/
make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Xxh64/_o/Xxh64.so bin/Codecs/
make -C CPP/7zip/Compress/Blake3 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Blake3 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Blake3/_o/Blake3.so bin/Codecs/

# static link
export CC="$MUSL_CC"
export CXX="$MUSL_CXX"
export CODEC_CC="$MUSL_CC"
export CODEC_CXX="$MUSL_CC"
make -C CPP/7zip/Bundles/Alone -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Bundles/Alone/_o/7za bin/
make -C CPP/7zip/Bundles/Alone7z -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone7z -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Bundles/Alone7z/_o/7zr bin/


make -C CPP/7zip/Bundles/Alone -f makefile.gcc clean
make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc clean
make -C CPP/7zip/Bundles/Alone7z -f makefile.gcc clean
make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc clean
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc clean
make -C CPP/7zip/UI/Client7z -f makefile.gcc clean
make -C CPP/7zip/UI/Console -f makefile.gcc clean
make -C C/Util/7z -f makefile.gcc clean
make -C C/Util/Lzma -f makefile.gcc clean
make -C CPP/7zip/Compress/Rar -f makefile.gcc clean
make -C CPP/7zip/Compress/Zstd -f makefile.gcc clean
make -C CPP/7zip/Compress/Lz4 -f makefile.gcc clean
make -C CPP/7zip/Compress/Lz5 -f makefile.gcc clean
make -C CPP/7zip/Compress/Lizard -f makefile.gcc clean
make -C CPP/7zip/Compress/Brotli -f makefile.gcc clean
make -C CPP/7zip/Compress/FLzma2 -f makefile.gcc clean
make -C CPP/7zip/Compress/Lzham -f makefile.gcc clean
make -C CPP/7zip/Compress/PKImplode -f makefile.gcc clean
make -C CPP/7zip/Compress/Bcm -f makefile.gcc clean
make -C CPP/7zip/Compress/Balz -f makefile.gcc clean
make -C CPP/7zip/Compress/Md5 -f makefile.gcc clean
make -C CPP/7zip/Compress/Sha512 -f makefile.gcc clean
make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc clean
make -C CPP/7zip/Compress/Blake3 -f makefile.gcc clean
