----

- to provide p7zip binary generator for macOS (x86-64/arm64) / Linux

----

Refer https://github.com/phoepsilonix/p7zip-full/blob/master/.github/workflows/p7zip-CI.yml for building manually.

# 7zz with extension method
This is the place for 7zz (Well known as 7zip-23.01 Linux version) to include major modern codecs such as Brotli, Fast LZMA2, LZ4, LZ5, Lizard and Zstd. In order to support multithreading for those addional codecs, this project depends on the [Multithreading Library](https://github.com/mcmilk/zstdmt).

## Codec overview
1. [Zstandard] v1.5.2 is a real-time compression algorithm, providing high compression ratios. It offers a very wide range of compression / speed trade-off, while being backed by a very fast decoder.
   - Levels: 1..22

2. [LZ4] v1.9.4 is lossless compression algorithm, providing compression speed at 400 MB/s per core (0.16 Bytes/cycle). It features an extremely fast decoder, with speed in multiple GB/s per core (0.71 Bytes/cycle). A high compression derivative, called LZ4_HC, is available, trading customizable CPU time for compression ratio.
   - Levels: 1..12

3. [Fast LZMA2] v1.0.1 is a LZMA2 compression algorithm, 20% to 100% faster than normal LZMA2 at levels 5 and above, but with a slightly lower compression ratio. It uses a parallel buffered radix matchfinder and some optimizations from Zstandard. The codec uses much less additional memory per thread than standard LZMA2.
   - Levels: 1..9

4. [Brotli] v1.0.9 is a generic-purpose lossless compression algorithm that compresses data using a combination of a modern variant of the LZ77 algorithm, Huffman coding and 2nd order context modeling, with a compression ratio comparable to the best currently available general-purpose compression methods. It is similar in speed with deflate but offers more dense compression.
   - Levels: 0..11

5. [LZ5] v1.5 is a modification of LZ4 which gives a better ratio at cost of slower compression and decompression.
   - Levels: 1..15

6. [Lizard] v1.0 is an efficient compressor with very fast decompression. It achieves compression ratio that is comparable to zip/zlib and zstd/brotli (at low and medium compression levels) at decompression speed of 1000 MB/s and faster.
   - Levels 10..19 (fastLZ4) are designed to give about 10% better decompression speed than LZ4
   - Levels 20..29 (LIZv1) are designed to give better ratio than LZ4 keeping 75% decompression speed
   - Levels 30..39 (fastLZ4 + Huffman) adds Huffman coding to fastLZ4
   - Levels 40..49 (LIZv1 + Huffman) give the best ratio, comparable to zlib and low levels of zstd/brotli, but with a faster decompression speed

7. [Lzham] v1.1 is a lossless data compression codec written in C/C++ (specifically C++03), with a compression ratio similar to LZMA but with 1.5x-8x faster decompression speed.
   - Levels: 1..9
   - Level: 1 best speed
   - Level: 9 best compression
   - Level: 10 best with extreme parsing (can be very slow) NOT RECOMMEND
   
1. PKImplode is LZ variant used in PKZIP. Implementation adopted from [StormLib] 9.24.

1. [BALZ] is ROLZ based compressor.

1. BCM v1.60 is BWT+CM based compressor.

## Build Binary
#### (Currently only supports CLI, if you want to do GUI please contact us)
1. Download src:
```
   git clone -b master https://github.com/jinfeihan57/p7zip.git
```
2. Use makefile to compile and build the binary 7zz:
```
    ./build_linux.sh
    OR
    ( cd p7zip/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc )
```
If you want build 7za:
```
   cd p7zip/CPP/7zip/Bundles/Alone && make -f makefile.gcc
```
7zr:
```
   cd p7zip/CPP/7zip/Bundles/Alone7z && make -f makefile.gcc
```

7z and Codecs(Excluding fast-lzma2):
```
export PLATFORM=${PLATFORM:-x64}
export OUTDIR="${OUTDIR:-g_x64}"
export O="b/${OUTDIR}"
export CC=${CC:-clang}
export CXX=${CXX:-clang++}
export LD=${LD:-ld.mold}

ARTIFACTS_DIR=bin/p7zip/
mkdir -p ${ARTIFACTS_DIR}

# 7z
make -C CPP/7zip/UI/Console -f makefile.gcc mkdir && make -C CPP/7zip/UI/Console -f makefile.gcc -j
cp CPP/7zip/UI/Console/b/${OUTDIR}/7z ${ARTIFACTS_DIR}

# 7z.so
make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Format7zF -f makefile.gcc -j
cp CPP/7zip/Bundles/Format7zF/b/${OUTDIR}/7z.so ${ARTIFACTS_DIR}

# Codecs
make -C CPP/7zip/Compress/Zstd -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Zstd -f makefile.gcc -j
cp CPP/7zip/Compress/Zstd/b/${OUTDIR}/Zstd.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Lz4 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lz4 -f makefile.gcc -j
cp CPP/7zip/Compress/Lz4/b/${OUTDIR}/Lz4.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Lz5 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lz5 -f makefile.gcc -j
cp CPP/7zip/Compress/Lz5/b/${OUTDIR}/Lz5.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Lizard -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lizard -f makefile.gcc -j
cp CPP/7zip/Compress/Lizard/b/${OUTDIR}/Lizard.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Brotli -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Brotli -f makefile.gcc -j
cp CPP/7zip/Compress/Brotli/b/${OUTDIR}/Brotli.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Lzham -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Lzham -f makefile.gcc -j
cp CPP/7zip/Compress/Lzham/b/${OUTDIR}/Lzham.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/PKImplode -f makefile.gcc mkdir && make -C CPP/7zip/Compress/PKImplode -f makefile.gcc -j
cp CPP/7zip/Compress/PKImplode/b/${OUTDIR}/PKImplode.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Bcm -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Bcm -f makefile.gcc -j
cp CPP/7zip/Compress/Bcm/b/${OUTDIR}/Bcm.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Balz -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Balz -f makefile.gcc -j
cp CPP/7zip/Compress/Balz/b/${OUTDIR}/Balz.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Md5 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Md5 -f makefile.gcc -j
cp CPP/7zip/Compress/Md5/b/${OUTDIR}/Md5.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Sha512 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Sha512 -f makefile.gcc -j
cp CPP/7zip/Compress/Sha512/b/${OUTDIR}/Sha512.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Xxh64 -f makefile.gcc -j
cp CPP/7zip/Compress/Xxh64/b/${OUTDIR}/Xxh64.so ${ARTIFACTS_DIR}Codecs/
make -C CPP/7zip/Compress/Blake3 -f makefile.gcc mkdir && make -C CPP/7zip/Compress/Blake3 -f makefile.gcc -j
cp CPP/7zip/Compress/Blake3/b/${OUTDIR}/Blake3.so ${ARTIFACTS_DIR}Codecs/
```

3. Test:
```
cd p7zip_test_utils/check/
bash check.sh `pwd`/../../bin/p7zip/7zz
```
4. The output should look like this:
```
XXX@ubuntu:./bin/7zip/7zz i
```
```
7-Zip (z) 23.01 (x64) : Copyright (c) 1999-2023 Igor Pavlov : 2023-06-20
 64-bit locale=ja_JP.UTF-8 Threads:4 OPEN_MAX:1024


Formats:
   C...F..........c.a.m+..  7z       7z            7 z BC AF ' 1C
    ......................  APFS     apfs img      offset=32 N X S B 00
    ......................  APM      apm           E R
    ......................  Ar       ar a deb udeb lib ! < a r c h > 0A
    ......................  Arj      arj           ` EA
    K.....O.....X.........  Base64   b64           
    ......O...............  COFF     obj           
    ...F..................  Cab      cab           M S C F 00 00 00 00
    ......................  Chm      chm chi chq chw I T S F 03 00 00 00 ` 00 00 00
    ......................  Compound msi msp doc xls ppt D0 CF 11 E0 A1 B1 1A E1
    ....M.................  Cpio     cpio          0 7 0 7 0  ||  C7 q  ||  q C7
    ......................  CramFS   cramfs        offset=16 C o m p r e s s e d 20 R O M F S
    .....G..B.............  Dmg      dmg           k o l y 00 00 00 04 00 00 02 00
    .........E............  ELF      elf           ␡ E L F
    ......................  Ext      ext ext2 ext3 ext4 img offset=1080 S EF
    ......................  FAT      fat img       offset=510 U AA
    ......................  FLV      flv           F L V 01
    ......................  GPT      gpt mbr       offset=512 E F I 20 P A R T 00 00 01 00
    ....M.................  HFS      hfs hfsx      offset=1024 B D  ||  H + 00 04  ||  H X 00 05
    ...F..................  Hxs      hxs hxi hxr hxq hxw lit I T O L I T L S 01 00 00 00 ( 00 00 00
    ......O...............  IHex     ihex          
    ......................  Iso      iso img       offset=32769 C D 0 0 1
    ......................  LP       lpimg img     offset=4096 g D l a 4 00 00 00
    ......................  Lzh      lzh lha       offset=2 - l h
    .......P..............  MBR      mbr           
    ....M....E............  MachO    macho         CE FA ED FE  ||  CF FA ED FE  ||  FE ED FA CE  ||  FE ED FA CF
    ......................  MsLZ     mslz          S Z D D 88 F0 ' 3 A
    ....M.................  Mub      mub           CA FE BA BE 00 00 00  ||  B9 FA F1 0E
    ......................  NTFS     ntfs img      offset=3 N T F S 20 20 20 20 00
    ...F.G................  Nsis     nsis          offset=4 EF BE AD DE N u l l s o f t I n s t
    .........E............  PE       exe dll sys   M Z
    ......................  Ppmd     pmd           8F AF AC 84
    ......................  QCOW     qcow qcow2 qcow2c Q F I FB 00 00 00
    ...F..................  Rar      rar r00       R a r ! 1A 07 00
    ...F..................  Rar5     rar r00       R a r ! 1A 07 01 00
    ......................  Rpm      rpm           ED AB EE DB
    K.....................  SWF      swf           F W S
    ....M.................  SWFc     swf (~.swf)   C W S  ||  Z W S
    ......................  Sparse   simg img      : FF & ED 01 00
    ......................  Split    001           
    ....M.................  SquashFS squashfs      h s q s  ||  s q s h  ||  s h s q  ||  q s h s
    .........E............  TE       te            V Z
    ...FM.................  UEFIc    scap          BD 86 f ; v 0D 0 @ B7 0E B5 Q 9E / C5 A0  ||  8B A6 < J # w FB H 80 = W 8C C1 FE C4 M  ||  B9 82 91 S B5 AB 91 C B6 9A E3 A9 C F7 / CC
    ...FM.................  UEFIf    uefif         offset=16 D9 T 93 z h 04 J D 81 CE 0B F6 17 D8 90 DF  ||  x E5 8C 8C = 8A 1C O 99 5 89 a 85 C3 - D3
    ....M.O...............  Udf      udf iso img   offset=32768 00 B E A 0 1 01 00  ||  01 C D 0 0 1
    ......................  VDI      vdi           offset=64 ␡ 10 DA BE
    .....G................  VHD      vhd           c o n e c t i x 00 00
    ......................  VHDX     vhdx avhdx    v h d x f i l e
    ......................  VMDK     vmdk          K D M V
    ......................  Xar      xar pkg xip   x a r ! 00 1C
    ......................  Z        z taz (.tar)  1F 9D
   CK.....................  bzip2    bz2 bzip2 tbz2 (.tar) tbz (.tar) B Z h
   CK.................m+..  gzip     gz gzip tgz (.tar) tpz (.tar) apk (.tar) 1F 8B 08
   CK.....................  lizard   liz tliz (.tar) 0 x 1 8 4 D 2 2 0 6 00
   CK.....................  lz4      lz4 tlz4 (.tar) 0 x 1 8 4 D 2 2 0 4 00
   CK.....................  lz5      lz5 tlz5 (.tar) 0 x 1 8 4 D 2 2 0 5 00
    K.....................  lzip     lz tlz (.tar) L Z I P 01
    K.....O...............  lzma     lzma          
    K.....................  lzma86   lzma86        
   C......O...LH......m+..  tar      tar ova       offset=257 u s t a r
   C.SN.......LH..c.a.m+..  wim      wim swm esd ppkg M S W I M 00 00 00
   CK.....................  xz       xz txz (.tar) FD 7 z X Z 00
   C...FMG........c.a.m+..  zip      zip z01 zipx jar xpi odt ods docx xlsx epub ipa apk appx P K 03 04  ||  P K 05 06  ||  P K 06 06  ||  P K 07 08 P K  ||  P K 0 0 P K
   CK.....................  zstd     zst tzstd (.tar) 0 x F D 2 F B 5 2 2 . . 2 8 00
   CK.....O.....XC........  Hash     sha256 sha512 sha224 sha384 sha1 sha md5 crc32 crc64 asc cksum 

Codecs:
   4ED   303011B BCJ2
    EDF  3030103 BCJ
    EDF  3030205 PPC
    EDF  3030401 IA64
    EDF  3030501 ARM
    EDF  3030701 ARMT
    EDF  3030805 SPARC
    EDF        A ARM64
    EDF    20302 Swap2
    EDF    20304 Swap4
    ED     40202 BZip2
    ED         0 Copy
    ED     40109 Deflate64
    ED     40108 Deflate
    EDF        3 Delta
    ED        21 LZMA2
    ED     30101 LZMA
    ED     30401 PPMD
    ED   4F71104 LZ4
    ED   4F71102 BROTLI
    ED   4F71106 LIZARD
    ED   4F71105 LZ5
    ED   4F71001 LZHAM
    ED   4F71101 ZSTD
    ED     40114 ZSTD-PK
    ED     4015D ZSTD-WZ
     D     40301 Rar1
     D     40302 Rar2
     D     40303 Rar3
     D     40305 Rar5
    EDF  6F10701 7zAES
    EDF  6F00181 AES256CBC
    ED     4010A PKImplode
    ED        21 FLZMA2

Hashers:
      4        1 CRC32
     20      201 SHA1
     32        A SHA256
      8        4 CRC64
     32      202 BLAKE2sp
     16      205 MD2
     16      206 MD4
     16      207 MD5
     48      208 SHA384
     64      209 SHA512
      4      203 XXH32
      8      204 XXH64
     32      20A BLAKE3
```

## Usage

- You can create `.7z` files, with [LZ4] [Fast LZMA2] [Brotli] [LZ5] [Lizard] and [Zstandard] method.
```
7zz a archiv.7z -m0=zstd 
7zz a archiv.7z -m0=zstd -mx3
7zz a archiv.7z -m0=zstd -mx22 
7zz a archiv.7z -m0=lz4 -mxN  ...
```

## License and redistribution

- the same as the Mainline [7-Zip], which means GNU LGPL

## Links

- [7-Zip Homepage](https://www.7-zip.org/)

## Version Information

- 7zz Version 22.01
  - [LZ4] Version 1.9.4
  - [Zstandard] Version 1.5.2
  - [Fast LZMA2] Version v1.0.1
  - [Brotli] Version v1.0.9
  - [LZ5] Version v1.5
  - [Lizard] Version 1.0
  - [LZHAM] Version 1.1
  - [StormLib] Version 9.24
  - [BALZ] Version 1.20
  - BCM Version 1.60

## Working Plan
 - [check here]()

[7-Zip]:https://www.7-zip.org/
[LZ4]:https://github.com/lz4/lz4/
[Zstandard]:https://github.com/facebook/zstd/
[Fast LZMA2]:https://github.com/conor42/fast-lzma2
[Brotli]:https://github.com/google/brotli/
[LZ5]:https://github.com/inikep/lz5/
[Lizard]:https://github.com/inikep/lizard/
[StormLib]:https://github.com/ladislav-zezula/StormLib
[BALZ]:https://sourceforge.net/projects/balz/
