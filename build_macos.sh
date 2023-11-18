#!/bin/bash
set -e

export PATH="/usr/local/bin:/usr/local/opt/llvm/bin:$PATH"
export CC=clang
export CXX=clang++
export LD=ld.mold

export PLATFORM=${PLATFORM:-x64}
export CMPL=${CMPL:-cmpl_gcc_x64}
export OUTDIR="${OUTDIR:-m_x64}"
export CC=${CC:-gcc}
export CXX=${CXX:-g++}
export LD=${LD:-ld.mold}
export LD=ld.mold

#llvm
#export CFLAGS_ADD="-Wno-error=unused-command-line-argument -Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter -I/usr/local/opt/llvm/include"
#export LDFLAGS_ADD="-Wno-error=unused-command-line-argument -L/usr/local/opt/llvm/lib -L/usr/local/opt/llvm/lib/c++ -Wl,-rpath,/usr/local/opt/llvm/lib/c++"

# zig 
#export CFLAGS_ADD="-Wno-error=unused-command-line-argument -Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter"
#export LDFLAGS_ADD="-Wno-error=unused-command-line-argument -Wl,-s"
ARTIFACTS_DIR=bin/p7zip/
mkdir -p ${ARTIFACTS_DIR}

export PLATFORM=x64
export CMPL=cmpl_clang_x64
export OUTDIR=m_${PLATFORM}
export O=b/${OUTDIR}
export IS_X64=1
export IS_X86=
export IS_ARM64=
export CROSS_COMPILE=
export MY_ARCH="-arch x86_64"
export USE_ASM=
export CC="${CROSS_COMPILE}clang"
export CXX="${CROSS_COMPILE}clang++"
export USE_CLANG=1

#export CFLAGS_ADD="-Wno-error=unused-command-line-argument -Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter -I/usr/local/opt/llvm/include"
#export LDFLAGS_ADD="-Wl,-s -Wno-error=unused-command-line-argument -L/usr/local/opt/llvm/lib -L/usr/local/opt/llvm/lib/c++ -Wl,-rpath,/usr/local/opt/llvm/lib/c++"
export CFLAGS_ADD="-Wno-error=unused-command-line-argument -Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter"
export LDFLAGS_ADD="-fuse-ld=${LD/ld./} -Wno-error=unused-command-line-argument -Wl,-s"
#export CFLAGS_ADD="${CFLAGS_ADD} -arch x86_64"
#export LDFLAGS_ADD="${LDFLAGS_ADD} -arch x86_64"

(cd Codecs/brotli && patch -p1 -i ../../brotli.patch)
source ./zig-macos-x86_64.sh
export MACFLAGS="-c"
make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc -j

<<COMMENTOUT
make -C CPP/7zip/UI/Console -f makefile.gcc mkdir && make -C CPP/7zip/UI/Console -f makefile.gcc -j
make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc -j
make -C CPP/7zip/Compress/Zstd -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Zstd -f makefile.gcc -j
make -C CPP/7zip/Compress/Lz4 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lz4 -f makefile.gcc -j
make -C CPP/7zip/Compress/Lz5 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lz5 -f makefile.gcc -j
make -C CPP/7zip/Compress/Lizard -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lizard -f makefile.gcc -j
make -C CPP/7zip/Compress/Brotli -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Brotli -f makefile.gcc -j
make -C CPP/7zip/Compress/Lzham -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lzham -f makefile.gcc -j
make -C CPP/7zip/Compress/PKImplode -f makefile.gcc mkdir && make -C CPP/7zip/Compress/PKImplode -f makefile.gcc -j
make -C CPP/7zip/Compress/Bcm -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Bcm -f makefile.gcc -j
make -C CPP/7zip/Compress/Balz -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Balz -f makefile.gcc -j
make -C CPP/7zip/Compress/Md5 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Md5 -f makefile.gcc -j
make -C CPP/7zip/Compress/Sha512 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Sha512 -f makefile.gcc -j
make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc -j
make -C CPP/7zip/Compress/Blake3 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Blake3 -f makefile.gcc -j

lipo CPP/7zip/UI/Console/${O}/7z -create -output ${ARTIFACTS_DIR}/7z
lipo CPP/7zip/Bundles/Format7zF/${O}/7z.so -create -output ${ARTIFACTS_DIR}/7z.so
lipo CPP/7zip/Bundles/Alone2/${O}/7zz -create -output ${ARTIFACTS_DIR}/7zz
lipo CPP/7zip/Compress/Zstd/${O}/Zstd.so -create -output ${ARTIFACTS_DIR}/Codecs/Zstd.so
lipo CPP/7zip/Compress/Lz4/${O}/Lz4.so -create -output ${ARTIFACTS_DIR}/Codecs/Lz4.so
lipo CPP/7zip/Compress/Lz5/${O}/Lz5.so -create -output ${ARTIFACTS_DIR}/Codecs/Lz5.so
lipo CPP/7zip/Compress/Lizard/${O}/Lizard.so -create -output ${ARTIFACTS_DIR}/Codecs/Lizard.so
lipo CPP/7zip/Compress/Brotli/${O}/Brotli.so -create -output ${ARTIFACTS_DIR}/Codecs/Brotli.so
lipo CPP/7zip/Compress/Lzham/${O}/Lzham.so -create -output ${ARTIFACTS_DIR}/Codecs/Lzham.so
lipo CPP/7zip/Compress/PKImplode/${O}/PKImplode.so -create -output ${ARTIFACTS_DIR}/Codecs/PKImplode.so
lipo CPP/7zip/Compress/Bcm/${O}/Bcm.so -create -output ${ARTIFACTS_DIR}/Codecs/Bcm.so
lipo CPP/7zip/Compress/Balz/${O}/Balz.so -create -output ${ARTIFACTS_DIR}/Codecs/Balz.so
lipo CPP/7zip/Compress/Md5/${O}/Md5.so -create -output ${ARTIFACTS_DIR}/Codecs/Md5.so
lipo CPP/7zip/Compress/Sha512/${O}/Sha512.so -create -output ${ARTIFACTS_DIR}/Codecs/Sha512.so
lipo CPP/7zip/Compress/Xxh64/${O}/Xxh64.so -create -output ${ARTIFACTS_DIR}/Codecs/Xxh64.so
lipo CPP/7zip/Compress/Blake3/${O}/Blake3.so -create -output ${ARTIFACTS_DIR}/Codecs/Blake3.so
COMMENTOUT

export PLATFORM=arm64
export OUTDIR=m_${PLATFORM}
export O=b/${OUTDIR}
export IS_X64=
export IS_X86=
export IS_ARM64=1
export CROSS_COMPILE=
export MY_ARCH="-arch arm64"
export USE_ASM=
export CC="${CROSS_COMPILE}clang"
export CXX="${CROSS_COMPILE}clang++"
export USE_CLANG=1
export ASM=${CC}
export MY_ASM=${CC}

export CFLAGS_ADD="-Wno-error=unused-command-line-argument -Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter -I/usr/local/opt/llvm/include"
export LDFLAGS_ADD="-Wl,-s -Wno-error=unused-command-line-argument -L/usr/local/opt/llvm/lib -L/usr/local/opt/llvm/lib/c++ -Wl,-rpath,/usr/local/opt/llvm/lib/c++"
export CFLAGS_ADD="-mcrypto -Wno-error=unused-command-line-argument -Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter"
export LDFLAGS_ADD="-fuse-ld=${LD/ld./} -Wno-error=unused-command-line-argument -Wl,-s"
#export CFLAGS_ADD="${CFLAGS_ADD} -arch arm64"
#export LDFLAGS_ADD="${LDFLAGS_ADD} -arch arm64"
#(cd Codecs/lzham_codec_devel/ && patch -p1 -i ../../lzham.patch)
source ./zig-macos-arm.sh
make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc -j

<<COMMENTOUT
make -C CPP/7zip/UI/Console -f makefile.gcc mkdir && make -C CPP/7zip/UI/Console -f makefile.gcc -j
make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/UI/Console -f makefile.gcc mkdir && make -C CPP/7zip/UI/Console -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/Zstd -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Zstd -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/Lz4 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lz4 -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/Lz5 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lz5 -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/Lizard -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lizard -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/Brotli -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Brotli -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/Lzham -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lzham -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/PKImplode -f makefile.gcc mkdir && make -C CPP/7zip/Compress/PKImplode -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/Bcm -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Bcm -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/Balz -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Balz -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/Md5 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Md5 -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/Sha512 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Sha512 -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
make -C CPP/7zip/Compress/Blake3 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Blake3 -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
COMMENTOUT

<<COMMENTOUT
lipo CPP/7zip/UI/Console/b/m_x64/7z CPP/7zip/UI/Console/b/m_arm64/7z -create -output ${ARTIFACTS_DIR}/7z
lipo CPP/7zip/Bundles/Format7zF/b/m_x64/7z.so CPP/7zip/Bundles/Format7zF/b/m_arm64/7z.so -create -output ${ARTIFACTS_DIR}/7z.so
lipo CPP/7zip/Compress/Zstd/b/m_x64/Zstd.so CPP/7zip/Compress/Zstd/b/m_arm64/Zstd.so -create -output ${ARTIFACTS_DIR}/Codecs/Zstd.so
lipo CPP/7zip/Compress/Lz4/b/m_x64/Lz4.so CPP/7zip/Compress/Lz4/b/m_arm64/Lz4.so -create -output ${ARTIFACTS_DIR}/Codecs/Lz4.so
lipo CPP/7zip/Compress/Lz5/b/m_x64/Lz5.so CPP/7zip/Compress/Lz5/b/m_arm64/Lz5.so -create -output ${ARTIFACTS_DIR}/Codecs/Lz5.so
lipo CPP/7zip/Compress/Lizard/b/m_x64/Lizard.so CPP/7zip/Compress/Lizard/b/m_arm64/Lizard.so -create -output ${ARTIFACTS_DIR}/Codecs/Lizard.so
lipo CPP/7zip/Compress/Brotli/b/m_x64/Brotli.so CPP/7zip/Compress/Brotli/b/m_arm64/Brotli.so -create -output ${ARTIFACTS_DIR}/Codecs/Brotli.so
lipo CPP/7zip/Compress/Lzham/b/m_x64/Lzham.so CPP/7zip/Compress/Lzham/b/m_arm64/Lzham.so -create -output ${ARTIFACTS_DIR}/Codecs/Lzham.so
lipo CPP/7zip/Compress/PKImplode/b/m_x64/PKImplode.so CPP/7zip/Compress/PKImplode/b/m_arm64/PKImplode.so -create -output ${ARTIFACTS_DIR}/Codecs/PKImplode.so
lipo CPP/7zip/Compress/Bcm/b/m_x64/Bcm.so CPP/7zip/Compress/Bcm/b/m_arm64/Bcm.so -create -output ${ARTIFACTS_DIR}/Codecs/Bcm.so
lipo CPP/7zip/Compress/Balz/b/m_x64/Balz.so CPP/7zip/Compress/Balz/b/m_arm64/Balz.so -create -output ${ARTIFACTS_DIR}/Codecs/Balz.so
lipo CPP/7zip/Compress/Md5/b/m_x64/Md5.so CPP/7zip/Compress/Md5/b/m_arm64/Md5.so -create -output ${ARTIFACTS_DIR}/Codecs/Md5.so
lipo CPP/7zip/Compress/Sha512/b/m_x64/Sha512.so CPP/7zip/Compress/Sha512/b/m_arm64/Sha512.so -create -output ${ARTIFACTS_DIR}/Codecs/Sha512.so
lipo CPP/7zip/Compress/Xxh64/b/m_x64/Xxh64.so CPP/7zip/Compress/Xxh64/b/m_arm64/Xxh64.so -create -output ${ARTIFACTS_DIR}/Codecs/Xxh64.so
lipo CPP/7zip/Compress/Blake3/b/m_x64/Blake3.so CPP/7zip/Compress/Blake3/b/m_arm64/Blake3.so -create -output ${ARTIFACTS_DIR}/Codecs/Blake3.so

COMMENTOUT

lipo CPP/7zip/Bundles/Alone2/b/m_x64/7zz CPP/7zip/Bundles/Alone2/b/m_arm64/7zz -create -output ${ARTIFACTS_DIR}/7zz
lipo CPP/7zip/Bundles/SFXCon/b/m_x64/7zCon.sfx CPP/7zip/Bundles/SFXCon/b/m_arm64/7zCon.sfx -create -output ${ARTIFACTS_DIR}/7zCon.sfx
<<COMMENTOUT
make -C CPP/7zip/Bundles/Alone -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone -f makefile.gcc -j
make -C CPP/7zip/Bundles/Alone -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
lipo CPP/7zip/Bundles/Alone/b/m_x64/7za CPP/7zip/Bundles/Alone/b/m_arm64/7za -create -output ${ARTIFACTS_DIR}/7za
make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j
make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j
lipo CPP/7zip/Bundles/Alone2/b/m_x64/7zz CPP/7zip/Bundles/Alone2/b/m_arm64/7zz -create -output ${ARTIFACTS_DIR}/7zz
make -C CPP/7zip/Bundles/Alone7z -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone7z -f makefile.gcc -j
make -C CPP/7zip/Bundles/Alone7z -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone7z -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
lipo CPP/7zip/Bundles/Alone7z/b/m_x64/7zr CPP/7zip/Bundles/Alone7z/b/m_arm64/7zr -create -output ${ARTIFACTS_DIR}/7zr
make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j
make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j
lipo CPP/7zip/Bundles/Format7zF/b/m_x64/7z.so CPP/7zip/Bundles/Format7zF/b/m_arm64/7z.so -create -output ${ARTIFACTS_DIR}/7z.so
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc -j
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
lipo CPP/7zip/Bundles/SFXCon/b/m_x64/7zCon.sfx CPP/7zip/Bundles/SFXCon/b/m_arm64/7zCon.sfx -create -output ${ARTIFACTS_DIR}/7zCon.sfx
make -C CPP/7zip/UI/Client7z -f makefile.gcc mkdir && make -C CPP/7zip/UI/Client7z -f makefile.gcc -j
make -C CPP/7zip/UI/Client7z -f makefile.gcc mkdir && make -C CPP/7zip/UI/Client7z -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
lipo CPP/7zip/UI/Client7z/b/m_x64/7zcl CPP/7zip/UI/Client7z/b/m_arm64/7zcl -create -output ${ARTIFACTS_DIR}/7zcl
make -C CPP/7zip/UI/Console -f makefile.gcc mkdir && make -C CPP/7zip/UI/Console -f makefile.gcc -j
make -C CPP/7zip/UI/Console -f makefile.gcc mkdir && make -C CPP/7zip/UI/Console -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
lipo CPP/7zip/UI/Console/b/m_x64/7z CPP/7zip/UI/Console/b/m_arm64/7z -create -output ${ARTIFACTS_DIR}/7z
make -C C/Util/7z -f ../../../CPP/7zip/cmpl_mac_x64.mak mkdir && make -C C/Util/7z -f ../../../CPP/7zip/cmpl_mac_x64.mak -j
make -C C/Util/7z -f ../../../CPP/7zip/cmpl_mac_arm64.mak mkdir && make -C C/Util/7z -f ../../../CPP/7zip/cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j
lipo C/Util/7z/b/m_x64/7zdec C/Util/7z/b/m_arm64/7zdec -create -output ${ARTIFACTS_DIR}/7zdec
make -C C/Util/Lzma -f ../../../CPP/7zip/cmpl_mac_x64.mak mkdir && make -C C/Util/Lzma -f ../../../CPP/7zip/cmpl_mac_x64.mak -j
make -C C/Util/Lzma -f ../../../CPP/7zip/cmpl_mac_arm64.mak mkdir && make -C C/Util/Lzma -f ../../../CPP/7zip/cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j
lipo C/Util/Lzma/b/m_x64/7lzma C/Util/Lzma/b/m_arm64/7lzma -create -output ${ARTIFACTS_DIR}/7lzma
make -C CPP/7zip/Compress/Rar -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Rar -f makefile.gcc -j
make -C CPP/7zip/Compress/Rar -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Rar -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
lipo CPP/7zip/Compress/Rar/b/m_x64/Rar.so CPP/7zip/Compress/Rar/b/m_arm64/Rar.so -create -output ${ARTIFACTS_DIR}/Codecs/Rar.so

make -C CPP/7zip/Compress/FLzma2 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/FLzma2 -f makefile.gcc -j
make -C CPP/7zip/Compress/FLzma2 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/FLzma2 -f makefile.gcc CROSS_COMPILE=arm64-apple-darwin- -j
lipo CPP/7zip/Compress/FLzma2/b/m_x64/FLzma2.so CPP/7zip/Compress/FLzma2/b/m_arm64/FLzma2.so -create -output ${ARTIFACTS_DIR}/Codecs/FLzma2.so
COMMENTOUT


make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc clean
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc clean
<<COMMENTOUT
make -C CPP/7zip/Bundles/Alone -f makefile.gcc clean
make -C CPP/7zip/Bundles/Alone -f makefile.gcc clean
make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc clean
make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc clean
make -C CPP/7zip/Bundles/Alone7z -f makefile.gcc clean
make -C CPP/7zip/Bundles/Alone7z -f makefile.gcc clean
make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc clean
make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc clean
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc clean
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc clean
make -C CPP/7zip/UI/Client7z -f makefile.gcc clean
make -C CPP/7zip/UI/Client7z -f makefile.gcc clean
make -C CPP/7zip/UI/Console -f makefile.gcc clean
make -C CPP/7zip/UI/Console -f makefile.gcc clean
make -C C/Util/7z -f ../../../CPP/7zip/cmpl_mac_x64.mak clean
make -C C/Util/7z -f ../../../CPP/7zip/cmpl_mac_arm64.mak clean
make -C C/Util/Lzma -f ../../../CPP/7zip/cmpl_mac_x64.mak clean
make -C C/Util/Lzma -f ../../../CPP/7zip/cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Rar -f makefile.gcc clean
make -C CPP/7zip/Compress/Rar -f makefile.gcc clean
make -C CPP/7zip/Compress/Zstd -f makefile.gcc clean
make -C CPP/7zip/Compress/Zstd -f makefile.gcc clean
make -C CPP/7zip/Compress/Lz4 -f makefile.gcc clean
make -C CPP/7zip/Compress/Lz4 -f makefile.gcc clean
make -C CPP/7zip/Compress/Lz5 -f makefile.gcc clean
make -C CPP/7zip/Compress/Lz5 -f makefile.gcc clean
make -C CPP/7zip/Compress/Lizard -f makefile.gcc clean
make -C CPP/7zip/Compress/Lizard -f makefile.gcc clean
make -C CPP/7zip/Compress/Brotli -f makefile.gcc clean
make -C CPP/7zip/Compress/Brotli -f makefile.gcc clean
make -C CPP/7zip/Compress/FLzma2 -f makefile.gcc clean
make -C CPP/7zip/Compress/FLzma2 -f makefile.gcc clean
make -C CPP/7zip/Compress/Lzham -f makefile.gcc clean
make -C CPP/7zip/Compress/Lzham -f makefile.gcc clean
make -C CPP/7zip/Compress/PKImplode -f makefile.gcc clean
make -C CPP/7zip/Compress/PKImplode -f makefile.gcc clean
make -C CPP/7zip/Compress/Bcm -f makefile.gcc clean
make -C CPP/7zip/Compress/Bcm -f makefile.gcc clean
make -C CPP/7zip/Compress/Balz -f makefile.gcc clean
make -C CPP/7zip/Compress/Balz -f makefile.gcc clean
make -C CPP/7zip/Compress/Md5 -f makefile.gcc clean
make -C CPP/7zip/Compress/Md5 -f makefile.gcc clean
make -C CPP/7zip/Compress/Sha512 -f makefile.gcc clean
make -C CPP/7zip/Compress/Sha512 -f makefile.gcc clean
make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc clean
make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc clean
make -C CPP/7zip/Compress/Blake3 -f makefile.gcc clean
make -C CPP/7zip/Compress/Blake3 -f makefile.gcc clean
COMMENTOUT
