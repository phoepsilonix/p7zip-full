#!/bin/bash
set -e

export PATH="/usr/local/zig:$HOME/.local/bin:$PATH"
export CC=clang
export CXX=clang++
export LD=ld.mold

export PLATFORM=${PLATFORM:-x64}
export CMPL=${CMPL:-cmpl_gcc_x64}
export OUTDIR="${OUTDIR:-g_x64}"
export O="b/${OUTDIR:-g_x64}"
export CC=${CC:-gcc}
export CXX=${CXX:-g++}
export LD=${LD:-ld.mold}
if [[ $CC =~ *gcc ]]; then
    export CFLAGS_ADD="-Wno-error=unused-command-line-argument -Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter"
else
    export CFLAGS_ADD="-Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter"
fi
export LDFLAGS_ADD="-fuse-ld=${LD/ld./} -Wl,-s -Wno-error=unused-command-line-argument  -Wl,-z,relro,-z,now -fPIE -fpie"
#export LDFLAGS_ADD="-Wno-error=unused-command-line-argument"
# zig build
export CFLAGS_ADD="${CFLAGS_ADD} -DZ7_AFFINITY_DISABLE"

#export FLAGS="CROSS_COMPILE=i686-linux-gnu-"
#export CROSS_COMPILE="i686-linux-gnu-"

ARTIFACTS_DIR=bin/p7zip/
mkdir -p ${ARTIFACTS_DIR}

<<COMMENTOUT
mkdir -p ${ARTIFACTS_DIR}/Codecs

make -C CPP/7zip/Bundles/Alone -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Bundles/Alone/b/${OUTDIR}/7za ${ARTIFACTS_DIR}
make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j
cp CPP/7zip/Bundles/Alone2/b/${OUTDIR}/7zz ${ARTIFACTS_DIR}
make -C CPP/7zip/Bundles/Alone7z -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone7z -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Bundles/Alone7z/b/${OUTDIR}/7zr ${ARTIFACTS_DIR}
make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j
cp CPP/7zip/Bundles/Format7zF/b/${OUTDIR}/7z.so ${ARTIFACTS_DIR}
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Bundles/SFXCon/b/${OUTDIR}/7zCon.sfx ${ARTIFACTS_DIR}
make -C CPP/7zip/UI/Client7z -f makefile.gcc mkdir && make -C CPP/7zip/UI/Client7z -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/UI/Client7z/b/${OUTDIR}/7zcl ${ARTIFACTS_DIR}
make -C CPP/7zip/UI/Console -f makefile.gcc mkdir && make -C CPP/7zip/UI/Console -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/UI/Console/b/${OUTDIR}/7z ${ARTIFACTS_DIR}
make -C C/Util/7z -f ../../../CPP/7zip/${CMPL}.mak mkdir && make -C C/Util/7z -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp C/Util/7z/b/${OUTDIR}/7zdec ${ARTIFACTS_DIR}
make -C C/Util/Lzma -f ../../../CPP/7zip/${CMPL}.mak mkdir && make -C C/Util/Lzma -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp C/Util/Lzma/b/${OUTDIR}/7lzma ${ARTIFACTS_DIR}
make -C CPP/7zip/Compress/Rar -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Rar -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Rar/b/${OUTDIR}/Rar.so ${ARTIFACTS_DIR}Codecs/

make -C CPP/7zip/Compress/FLzma2 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/FLzma2 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/FLzma2/b/${OUTDIR}/FLzma2.so ${ARTIFACTS_DIR}Codecs/

make -C CPP/7zip/UI/Console -f makefile.gcc mkdir && make -C CPP/7zip/UI/Console -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/UI/Console/b/${OUTDIR}/7z ${ARTIFACTS_DIR}

make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Bundles/Format7zF/b/${OUTDIR}/7z.so ${ARTIFACTS_DIR}
COMMENTOUT

export MACFLAGS=""
make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Bundles/Alone2/b/${OUTDIR}/7zz ${ARTIFACTS_DIR}
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Bundles/SFXCon/b/${OUTDIR}/7zCon.sfx ${ARTIFACTS_DIR}

<<COMMENTOUT
make -C CPP/7zip/Compress/Zstd -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Zstd -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Zstd/b/${OUTDIR}/Zstd.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Lz4 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lz4 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Lz4/b/${OUTDIR}/Lz4.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Lz5 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lz5 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Lz5/b/${OUTDIR}/Lz5.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Lizard -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lizard -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Lizard/b/${OUTDIR}/Lizard.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Brotli -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Brotli -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Brotli/b/${OUTDIR}/Brotli.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Lzham -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lzham -f makefile.gcc CC="$CC" CXX="$CXX" CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Lzham/b/${OUTDIR}/Lzham.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/PKImplode -f makefile.gcc mkdir && make -C CPP/7zip/Compress/PKImplode -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/PKImplode/b/${OUTDIR}/PKImplode.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Bcm -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Bcm -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Bcm/b/${OUTDIR}/Bcm.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Balz -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Balz -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Balz/b/${OUTDIR}/Balz.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Md5 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Md5 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Md5/b/${OUTDIR}/Md5.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Sha512 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Sha512 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Sha512/b/${OUTDIR}/Sha512.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Xxh64/b/${OUTDIR}/Xxh64.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Blake3 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Blake3 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Compress/Blake3/b/${OUTDIR}/Blake3.so ${ARTIFACTS_DIR}Codecs/

COMMENTOUT

make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc clean
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc clean
<<COMMENTOUT
make -C CPP/7zip/Bundles/Alone -f makefile.gcc clean
make -C CPP/7zip/Bundles/Alone7z -f makefile.gcc clean
make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc clean
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc clean
make -C CPP/7zip/UI/Client7z -f makefile.gcc clean
make -C CPP/7zip/UI/Console -f makefile.gcc clean
make -C C/Util/7z -f ../../../CPP/7zip/${CMPL}.mak clean
make -C C/Util/Lzma -f ../../../CPP/7zip/${CMPL}.mak clean
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
COMMENTOUT
