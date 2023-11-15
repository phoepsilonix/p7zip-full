#!/bin/sh
set -e

export CC=clang
export CXX=clang++
export LD=ld.mold
export CFLAGS_ADD="-Wno-error=unused-command-line-argument -Wno-error=unused-but-set-variable -Wno-error=unused-but-set-parameter"
export LDFLAGS_ADD="-fuse-ld=mold -Wno-error=unused-command-line-argument"

ARTIFACTS_DIR=bin/p7zip/
mkdir -p ${ARTIFACTS_DIR}/Codecs
make -C CPP/7zip/UI/Console -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/UI/Console -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/UI/Console -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/UI/Console -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/UI/Console/b/m_x64/7z CPP/7zip/UI/Console/b/m_arm64/7z -create -output ${ARTIFACTS_DIR}/7z

make -C CPP/7zip/Bundles/Format7zF -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Bundles/Format7zF -f ../../cmpl_mac_x64.mak -j
make -C CPP/7zip/Bundles/Format7zF -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Bundles/Format7zF -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j
lipo CPP/7zip/Bundles/Format7zF/b/m_x64/7z.so CPP/7zip/Bundles/Format7zF/b/m_arm64/7z.so -create -output ${ARTIFACTS_DIR}/7z.so

make -C CPP/7zip/Bundles/Alone2 -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Bundles/Alone2 -f ../../cmpl_mac_x64.mak -j
make -C CPP/7zip/Bundles/Alone2 -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Bundles/Alone2 -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j
lipo CPP/7zip/Bundles/Alone2/b/m_x64/7zz CPP/7zip/Bundles/Alone2/b/m_arm64/7zz -create -output ${ARTIFACTS_DIR}/7zz

<<COMMENTOUT
make -C CPP/7zip/Bundles/Alone -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Bundles/Alone -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Bundles/Alone -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Bundles/Alone -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Bundles/Alone/b/m_x64/7za CPP/7zip/Bundles/Alone/b/m_arm64/7za -create -output ${ARTIFACTS_DIR}/7za
make -C CPP/7zip/Bundles/Alone2 -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Bundles/Alone2 -f ../../cmpl_mac_x64.mak DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j16
make -C CPP/7zip/Bundles/Alone2 -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Bundles/Alone2 -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j16
lipo CPP/7zip/Bundles/Alone2/b/m_x64/7zz CPP/7zip/Bundles/Alone2/b/m_arm64/7zz -create -output ${ARTIFACTS_DIR}/7zz
make -C CPP/7zip/Bundles/Alone7z -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Bundles/Alone7z -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Bundles/Alone7z -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Bundles/Alone7z -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Bundles/Alone7z/b/m_x64/7zr CPP/7zip/Bundles/Alone7z/b/m_arm64/7zr -create -output ${ARTIFACTS_DIR}/7zr
make -C CPP/7zip/Bundles/Format7zF -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Bundles/Format7zF -f ../../cmpl_mac_x64.mak DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j16
make -C CPP/7zip/Bundles/Format7zF -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Bundles/Format7zF -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- DISABLE_RAR_COMPRESS=1 DISABLE_PKIMPLODE_COMPRESS=1 -j16
lipo CPP/7zip/Bundles/Format7zF/b/m_x64/7z.so CPP/7zip/Bundles/Format7zF/b/m_arm64/7z.so -create -output ${ARTIFACTS_DIR}/7z.so
make -C CPP/7zip/Bundles/SFXCon -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Bundles/SFXCon -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Bundles/SFXCon -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Bundles/SFXCon -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Bundles/SFXCon/b/m_x64/7zCon.sfx CPP/7zip/Bundles/SFXCon/b/m_arm64/7zCon.sfx -create -output ${ARTIFACTS_DIR}/7zCon.sfx
make -C CPP/7zip/UI/Client7z -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/UI/Client7z -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/UI/Client7z -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/UI/Client7z -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/UI/Client7z/b/m_x64/7zcl CPP/7zip/UI/Client7z/b/m_arm64/7zcl -create -output ${ARTIFACTS_DIR}/7zcl
make -C CPP/7zip/UI/Console -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/UI/Console -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/UI/Console -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/UI/Console -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/UI/Console/b/m_x64/7z CPP/7zip/UI/Console/b/m_arm64/7z -create -output ${ARTIFACTS_DIR}/7z
make -C C/Util/7z -f ../../../CPP/7zip/cmpl_mac_x64.mak mkdir && make -C C/Util/7z -f ../../../CPP/7zip/cmpl_mac_x64.mak -j16
make -C C/Util/7z -f ../../../CPP/7zip/cmpl_mac_arm64.mak mkdir && make -C C/Util/7z -f ../../../CPP/7zip/cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo C/Util/7z/b/m_x64/7zdec C/Util/7z/b/m_arm64/7zdec -create -output ${ARTIFACTS_DIR}/7zdec
make -C C/Util/Lzma -f ../../../CPP/7zip/cmpl_mac_x64.mak mkdir && make -C C/Util/Lzma -f ../../../CPP/7zip/cmpl_mac_x64.mak -j16
make -C C/Util/Lzma -f ../../../CPP/7zip/cmpl_mac_arm64.mak mkdir && make -C C/Util/Lzma -f ../../../CPP/7zip/cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo C/Util/Lzma/b/m_x64/7lzma C/Util/Lzma/b/m_arm64/7lzma -create -output ${ARTIFACTS_DIR}/7lzma
make -C CPP/7zip/Compress/Rar -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Rar -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Rar -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Rar -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Rar/b/m_x64/Rar.so CPP/7zip/Compress/Rar/b/m_arm64/Rar.so -create -output ${ARTIFACTS_DIR}/Codecs/Rar.so

make -C CPP/7zip/Compress/FLzma2 -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/FLzma2 -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/FLzma2 -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/FLzma2 -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/FLzma2/b/m_x64/FLzma2.so CPP/7zip/Compress/FLzma2/b/m_arm64/FLzma2.so -create -output ${ARTIFACTS_DIR}/Codecs/FLzma2.so
COMMENTOUT

make -C CPP/7zip/Compress/Zstd -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Zstd -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Zstd -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Zstd -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Zstd/b/m_x64/Zstd.so CPP/7zip/Compress/Zstd/b/m_arm64/Zstd.so -create -output ${ARTIFACTS_DIR}/Codecs/Zstd.so
make -C CPP/7zip/Compress/Lz4 -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Lz4 -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Lz4 -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Lz4 -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Lz4/b/m_x64/Lz4.so CPP/7zip/Compress/Lz4/b/m_arm64/Lz4.so -create -output ${ARTIFACTS_DIR}/Codecs/Lz4.so
make -C CPP/7zip/Compress/Lz5 -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Lz5 -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Lz5 -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Lz5 -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Lz5/b/m_x64/Lz5.so CPP/7zip/Compress/Lz5/b/m_arm64/Lz5.so -create -output ${ARTIFACTS_DIR}/Codecs/Lz5.so
make -C CPP/7zip/Compress/Lizard -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Lizard -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Lizard -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Lizard -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Lizard/b/m_x64/Lizard.so CPP/7zip/Compress/Lizard/b/m_arm64/Lizard.so -create -output ${ARTIFACTS_DIR}/Codecs/Lizard.so
make -C CPP/7zip/Compress/Brotli -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Brotli -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Brotli -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Brotli -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Brotli/b/m_x64/Brotli.so CPP/7zip/Compress/Brotli/b/m_arm64/Brotli.so -create -output ${ARTIFACTS_DIR}/Codecs/Brotli.so
make -C CPP/7zip/Compress/Lzham -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Lzham -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Lzham -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Lzham -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Lzham/b/m_x64/Lzham.so CPP/7zip/Compress/Lzham/b/m_arm64/Lzham.so -create -output ${ARTIFACTS_DIR}/Codecs/Lzham.so
make -C CPP/7zip/Compress/PKImplode -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/PKImplode -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/PKImplode -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/PKImplode -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/PKImplode/b/m_x64/PKImplode.so CPP/7zip/Compress/PKImplode/b/m_arm64/PKImplode.so -create -output ${ARTIFACTS_DIR}/Codecs/PKImplode.so
make -C CPP/7zip/Compress/Bcm -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Bcm -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Bcm -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Bcm -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Bcm/b/m_x64/Bcm.so CPP/7zip/Compress/Bcm/b/m_arm64/Bcm.so -create -output ${ARTIFACTS_DIR}/Codecs/Bcm.so
make -C CPP/7zip/Compress/Balz -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Balz -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Balz -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Balz -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Balz/b/m_x64/Balz.so CPP/7zip/Compress/Balz/b/m_arm64/Balz.so -create -output ${ARTIFACTS_DIR}/Codecs/Balz.so
make -C CPP/7zip/Compress/Md5 -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Md5 -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Md5 -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Md5 -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Md5/b/m_x64/Md5.so CPP/7zip/Compress/Md5/b/m_arm64/Md5.so -create -output ${ARTIFACTS_DIR}/Codecs/Md5.so
make -C CPP/7zip/Compress/Sha512 -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Sha512 -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Sha512 -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Sha512 -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Sha512/b/m_x64/Sha512.so CPP/7zip/Compress/Sha512/b/m_arm64/Sha512.so -create -output ${ARTIFACTS_DIR}/Codecs/Sha512.so
make -C CPP/7zip/Compress/Xxh64 -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Xxh64 -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Xxh64 -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Xxh64 -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Xxh64/b/m_x64/Xxh64.so CPP/7zip/Compress/Xxh64/b/m_arm64/Xxh64.so -create -output ${ARTIFACTS_DIR}/Codecs/Xxh64.so
make -C CPP/7zip/Compress/Blake3 -f ../../cmpl_mac_x64.mak mkdir && make -C CPP/7zip/Compress/Blake3 -f ../../cmpl_mac_x64.mak -j16
make -C CPP/7zip/Compress/Blake3 -f ../../cmpl_mac_arm64.mak mkdir && make -C CPP/7zip/Compress/Blake3 -f ../../cmpl_mac_arm64.mak CROSS_COMPILE=arm64-apple-darwin- -j16
lipo CPP/7zip/Compress/Blake3/b/m_x64/Blake3.so CPP/7zip/Compress/Blake3/b/m_arm64/Blake3.so -create -output ${ARTIFACTS_DIR}/Codecs/Blake3.so


make -C CPP/7zip/Bundles/Alone -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Bundles/Alone -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Bundles/Alone2 -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Bundles/Alone2 -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Bundles/Alone7z -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Bundles/Alone7z -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Bundles/Format7zF -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Bundles/Format7zF -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Bundles/SFXCon -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Bundles/SFXCon -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/UI/Client7z -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/UI/Client7z -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/UI/Console -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/UI/Console -f ../../cmpl_mac_arm64.mak clean
make -C C/Util/7z -f ../../../CPP/7zip/cmpl_mac_x64.mak clean
make -C C/Util/7z -f ../../../CPP/7zip/cmpl_mac_arm64.mak clean
make -C C/Util/Lzma -f ../../../CPP/7zip/cmpl_mac_x64.mak clean
make -C C/Util/Lzma -f ../../../CPP/7zip/cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Rar -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Rar -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Zstd -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Zstd -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Lz4 -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Lz4 -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Lz5 -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Lz5 -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Lizard -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Lizard -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Brotli -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Brotli -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/FLzma2 -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/FLzma2 -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Lzham -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Lzham -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/PKImplode -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/PKImplode -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Bcm -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Bcm -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Balz -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Balz -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Md5 -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Md5 -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Sha512 -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Sha512 -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Xxh64 -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Xxh64 -f ../../cmpl_mac_arm64.mak clean
make -C CPP/7zip/Compress/Blake3 -f ../../cmpl_mac_x64.mak clean
make -C CPP/7zip/Compress/Blake3 -f ../../cmpl_mac_arm64.mak clean
