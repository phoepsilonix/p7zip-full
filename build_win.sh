#!/bin/bash
set -e

export PATH="/usr/local/zig:$HOME/.local/bin:$PATH"
export CC=clang
export CXX=clang++
export LD=ld.mold

export PLATFORM=${PLATFORM:-x64}
export CMPL=${CMPL:-cmpl_gcc_x64}
export OUTDIR="${OUTDIR:-g_x64}"
export CC=${CC:-gcc}
export CXX=${CXX:-g++}
export LD=${LD:-ld.mold}
if [[ $CC =~ *clang ]]; then
    export CFLAGS_ADD="-Wno-error=unused-command-line-argument -Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter"
else
    export CFLAGS_ADD="-Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter"
fi
export LDFLAGS_ADD="-DMSYSTEM -fuse-ld=${LD/ld./} -Wno-error=unused-command-line-argument"

ARTIFACTS_DIR=bin/p7zip/
mkdir -p ${ARTIFACTS_DIR}

source ./zig-windows-x86_64.sh
export MSYSTEM=1
make -C CPP/7zip/UI/Console -f makefile.gcc mkdir && make -C CPP/7zip/UI/Console -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/UI/Console/b/${OUTDIR}/7z.exe bin/

<<COMMENTOUT
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Bundles/SFXCon/b/${OUTDIR}/7zCon.sfx.exe bin/7zCon.sfx

make -C CPP/7zip/Bundles/Alone2 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Bundles/Alone2 -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Bundles/Alone2/b/${OUTDIR}/7zz.exe bin/
make -C CPP/7zip/Bundles/Format7zF -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Bundles/Format7zF -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Bundles/Format7zF/b/${OUTDIR}/7z.dll bin/
make -C CPP/7zip/Bundles/Alone -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Bundles/Alone -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Bundles/Alone/b/${OUTDIR}/7za.exe bin/
make -C CPP/7zip/Bundles/Alone7z -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Bundles/Alone7z -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Bundles/Alone7z/b/${OUTDIR}/7zr.exe bin/
make -C CPP/7zip/Bundles/Format7zF -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Bundles/Format7zF -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j16
cp CPP/7zip/Bundles/Format7zF/b/${OUTDIR}/7z.dll bin/
make -C CPP/7zip/Bundles/SFXCon -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Bundles/SFXCon -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Bundles/SFXCon/b/${OUTDIR}/7zCon.sfx.exe bin/7zCon.sfx
make -C CPP/7zip/UI/Client7z -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/UI/Client7z -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/UI/Client7z/b/${OUTDIR}/7zcl.exe bin/
make -C CPP/7zip/UI/Console -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/UI/Console -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/UI/Console/b/${OUTDIR}/7z.exe bin/
make -C C/Util/7z -f ../../../CPP/7zip/${CMPL}.mak mkdir && make -C C/Util/7z -f ../../../CPP/7zip/${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp C/Util/7z/b/${OUTDIR}/7zdec.exe bin/
make -C C/Util/Lzma -f ../../../CPP/7zip/${CMPL}.mak mkdir && make -C C/Util/Lzma -f ../../../CPP/7zip/${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp C/Util/Lzma/b/${OUTDIR}/7lzma.exe bin/
make -C CPP/7zip/Compress/Rar -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Rar -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Rar/b/${OUTDIR}/Rar.dll bin/Codecs/
make -C CPP/7zip/Compress/Zstd -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Zstd -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16

make -C CPP/7zip/Compress/FLzma2 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/FLzma2 -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/FLzma2/b/${OUTDIR}/FLzma2.dll bin/Codecs/

cp CPP/7zip/Compress/Zstd/b/${OUTDIR}/Zstd.dll bin/Codecs/
make -C CPP/7zip/Compress/Lz4 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Lz4 -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Lz4/b/${OUTDIR}/Lz4.dll bin/Codecs/
make -C CPP/7zip/Compress/Lz5 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Lz5 -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Lz5/b/${OUTDIR}/Lz5.dll bin/Codecs/
make -C CPP/7zip/Compress/Lizard -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Lizard -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Lizard/b/${OUTDIR}/Lizard.dll bin/Codecs/
make -C CPP/7zip/Compress/Brotli -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Brotli -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Brotli/b/${OUTDIR}/Brotli.dll bin/Codecs/
make -C CPP/7zip/Compress/Lzham -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Lzham -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Lzham/b/${OUTDIR}/Lzham.dll bin/Codecs/
make -C CPP/7zip/Compress/PKImplode -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/PKImplode -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/PKImplode/b/${OUTDIR}/PKImplode.dll bin/Codecs/
make -C CPP/7zip/Compress/Bcm -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Bcm -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Bcm/b/${OUTDIR}/Bcm.dll bin/Codecs/
make -C CPP/7zip/Compress/Balz -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Balz -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Balz/b/${OUTDIR}/Balz.dll bin/Codecs/
make -C CPP/7zip/Compress/Md5 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Md5 -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Md5/b/${OUTDIR}/Md5.dll bin/Codecs/
make -C CPP/7zip/Compress/Sha512 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Sha512 -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Sha512/b/${OUTDIR}/Sha512.dll bin/Codecs/
make -C CPP/7zip/Compress/Xxh64 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Xxh64 -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Xxh64/b/${OUTDIR}/Xxh64.dll bin/Codecs/
make -C CPP/7zip/Compress/Blake3 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Blake3 -f ../../${CMPL}.mak CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j16
cp CPP/7zip/Compress/Blake3/b/${OUTDIR}/Blake3.dll bin/Codecs/

make -C CPP/7zip/Bundles/Alone -f ../../${CMPL}.mak clean
make -C CPP/7zip/Bundles/Alone2 -f ../../${CMPL}.mak clean
make -C CPP/7zip/Bundles/Alone7z -f ../../${CMPL}.mak clean
make -C CPP/7zip/Bundles/Format7zF -f ../../${CMPL}.mak clean
make -C CPP/7zip/Bundles/SFXCon -f ../../${CMPL}.mak clean
make -C CPP/7zip/UI/Client7z -f ../../${CMPL}.mak clean
make -C CPP/7zip/UI/Console -f ../../${CMPL}.mak clean
make -C C/Util/7z -f ../../../CPP/7zip/${CMPL}.mak clean
make -C C/Util/Lzma -f ../../../CPP/7zip/${CMPL}.mak clean
make -C CPP/7zip/Compress/Rar -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/Zstd -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/Lz4 -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/Lz5 -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/Lizard -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/Brotli -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/FLzma2 -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/Lzham -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/PKImplode -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/Bcm -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/Balz -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/Md5 -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/Sha512 -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/Xxh64 -f ../../${CMPL}.mak clean
make -C CPP/7zip/Compress/Blake3 -f ../../${CMPL}.mak clean
COMMENTOUT
make -C CPP/7zip/Bundles/Alone2 -f ../../${CMPL}.mak clean
make -C CPP/7zip/Bundles/SFXCon -f ../../${CMPL}.mak clean
