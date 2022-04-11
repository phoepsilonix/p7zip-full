#!/bin/sh
set -e

CMPL=${CMPL:-cmpl_gcc_x64}
OUTDIR=${OUTDIR:-g_x64}

mkdir -p bin/Codecs
make -C CPP/7zip/Bundles/Alone -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Bundles/Alone -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Bundles/Alone/b/${OUTDIR}/7za bin/
make -C CPP/7zip/Bundles/Alone2 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Bundles/Alone2 -f ../../${CMPL}.mak ${FLAGS} DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j16
cp CPP/7zip/Bundles/Alone2/b/${OUTDIR}/7zz bin/
make -C CPP/7zip/Bundles/Alone7z -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Bundles/Alone7z -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Bundles/Alone7z/b/${OUTDIR}/7zr bin/
make -C CPP/7zip/Bundles/Format7zF -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Bundles/Format7zF -f ../../${CMPL}.mak ${FLAGS} DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j16
cp CPP/7zip/Bundles/Format7zF/b/${OUTDIR}/7z.so bin/
make -C CPP/7zip/Bundles/SFXCon -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Bundles/SFXCon -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Bundles/SFXCon/b/${OUTDIR}/7zCon.sfx bin/
make -C CPP/7zip/UI/Client7z -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/UI/Client7z -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/UI/Client7z/b/${OUTDIR}/7zcl bin/
make -C CPP/7zip/UI/Console -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/UI/Console -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/UI/Console/b/${OUTDIR}/7z bin/
make -C C/Util/7z -f ../../../CPP/7zip/${CMPL}.mak mkdir && make -C C/Util/7z -f ../../../CPP/7zip/${CMPL}.mak ${FLAGS} -j16
cp C/Util/7z/b/${OUTDIR}/7zdec bin/
make -C C/Util/Lzma -f ../../../CPP/7zip/${CMPL}.mak mkdir && make -C C/Util/Lzma -f ../../../CPP/7zip/${CMPL}.mak ${FLAGS} -j16
cp C/Util/Lzma/b/${OUTDIR}/7lzma bin/
make -C CPP/7zip/Compress/Rar -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Rar -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Rar/b/${OUTDIR}/Rar.so bin/Codecs/
make -C CPP/7zip/Compress/Zstd -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Zstd -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Zstd/b/${OUTDIR}/Zstd.so bin/Codecs/
make -C CPP/7zip/Compress/Lz4 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Lz4 -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Lz4/b/${OUTDIR}/Lz4.so bin/Codecs/
make -C CPP/7zip/Compress/Lz5 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Lz5 -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Lz5/b/${OUTDIR}/Lz5.so bin/Codecs/
make -C CPP/7zip/Compress/Lizard -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Lizard -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Lizard/b/${OUTDIR}/Lizard.so bin/Codecs/
make -C CPP/7zip/Compress/Brotli -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Brotli -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Brotli/b/${OUTDIR}/Brotli.so bin/Codecs/
make -C CPP/7zip/Compress/FLzma2 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/FLzma2 -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/FLzma2/b/${OUTDIR}/FLzma2.so bin/Codecs/
make -C CPP/7zip/Compress/Lzham -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Lzham -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Lzham/b/${OUTDIR}/Lzham.so bin/Codecs/
make -C CPP/7zip/Compress/PKImplode -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/PKImplode -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/PKImplode/b/${OUTDIR}/PKImplode.so bin/Codecs/
make -C CPP/7zip/Compress/Bcm -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Bcm -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Bcm/b/${OUTDIR}/Bcm.so bin/Codecs/
make -C CPP/7zip/Compress/Balz -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Balz -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Balz/b/${OUTDIR}/Balz.so bin/Codecs/
make -C CPP/7zip/Compress/Md5 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Md5 -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Md5/b/${OUTDIR}/Md5.so bin/Codecs/
make -C CPP/7zip/Compress/Sha512 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Sha512 -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Sha512/b/${OUTDIR}/Sha512.so bin/Codecs/
make -C CPP/7zip/Compress/Xxh64 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Xxh64 -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Xxh64/b/${OUTDIR}/Xxh64.so bin/Codecs/
make -C CPP/7zip/Compress/Blake3 -f ../../${CMPL}.mak mkdir && make -C CPP/7zip/Compress/Blake3 -f ../../${CMPL}.mak ${FLAGS} -j16
cp CPP/7zip/Compress/Blake3/b/${OUTDIR}/Blake3.so bin/Codecs/

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
