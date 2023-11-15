Retrying to contact jinfeihan57 by https://github.com/jinfeihan57/p7zip/issues/179#issuecomment-1294270250 , let's see how it will go...

----

This repository's goal was these:

- to provide automated p7zip binary generator for Windows / macOS (x86-64/arm64) / Linux / Android
- to provide standalone Codecs plugin for PKImplode / BALZ / BCM

These goals have been already acheived. You can put Codecs directory to the same directory as 7z.so/dll (from official 7-zip or jinfeihan57/p7zip).

I'd like to have these patch merged into jinfeihan57/p7zip, but I had issue in resolving conflict, so I have given up.

Excuse: to utilize git's 3-way merge, I have suggested https://github.com/jinfeihan57/p7zip/issues/179 , but it was not adopted.

This repo has been archived (might be temporary unarchived when I got interested but it will happen rarely).

----

Refer https://github.com/cielavenir/p7zip/blob/main/.github/workflows/ci.yaml for building manually.

# 7zz with extension method
This is the place for 7zz (Well known as 7zip-22.01 Linux version) to include major modern codecs such as Brotli, Fast LZMA2, LZ4, LZ5, Lizard and Zstd. In order to support multithreading for those addional codecs, this project depends on the [Multithreading Library](https://github.com/mcmilk/zstdmt).

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
   git clone -b 7zip_21.02 https://github.com/jinfeihan57/p7zip.git
```
2. Use makefile to compile and build the binary 7zz:
```
   cd p7zip/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc
   OR
   cd p7zip/CPP/7zip/Bundles/Alone2 && make -j -f ../../cmpl_gcc.mak
```
If you want build 7za:
```
   cd p7zip/CPP/7zip/Bundles/Alone && make -f makefile.gcc
   OR
   cd p7zip/CPP/7zip/Bundles/Alone && make -j -f ../../cmpl_gcc.mak
```
7zr:
```
   cd p7zip/CPP/7zip/Bundles/Alone7z && make -f makefile.gcc
   OR
   cd p7zip/CPP/7zip/Bundles/Alone7z && make -j -f ../../cmpl_gcc.mak
```
or build 7z.so:
```
   cd p7zip/CPP/7zip/Bundles/Format7zF && make -f makefile.gcc
   OR
   cd p7zip/CPP/7zip/Bundles/Format7zF && make -j -f ../../cmpl_gcc.mak
```
3. Test:
```
   ./_o/7zz i
```
4. The output should look like this:
```
XXX@ubuntu:~/github/p7zip/CPP/7zip/Bundles/Alone2$ ./_o/7zz i

7-Zip (z) 21.02 alpha (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-05-06
 compiler: 7.5.0 GCC 7.5.0 64-bit locale=en_US.UTF-8 UTF8=+ use-UTF8=+ wchar_t=32-bit Files=64-bit Threads:2, Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz (806EA),AES


Formats:
                 APM      apm           E R
                 Ar       ar a deb udeb lib ! < a r c h > 0A
                 Arj      arj           ` EA
   K     O     X Base64   b64
  CK             bzip2    bz2 bzip2 tbz2 (.tar) tbz (.tar) B Z h
                 Compound msi msp doc xls ppt D0 CF 11 E0 A1 B1 1A E1
       M         Cpio     cpio          0 7 0 7 0  ||  C7 q  ||  q C7
                 CramFS   cramfs        offset=16 C o m p r e s s e d 20 R O M F S
        G  B     Dmg      dmg           k o l y 00 00 00 04 00 00 02 00
            E    ELF      elf           E L F
                 Ext      ext ext2 ext3 ext4 img offset=1080 S EF
                 FAT      fat img       offset=510 U AA
                 FLV      flv           F L V 01
  CK             gzip     gz gzip tgz (.tar) tpz (.tar) apk (.tar) 1F 8B 08
                 GPT      gpt mbr       offset=512 E F I 20 P A R T 00 00 01 00
       M         HFS      hfs hfsx      offset=1024 B D  ||  H + 00 04  ||  H X 00 05
         O       IHex     ihex
                 Lzh      lzh lha       offset=2 - l h
   K     O       lzma     lzma
   K             lzma86   lzma86
       M    E    MachO    macho         CE FA ED FE  ||  CF FA ED FE  ||  FE ED FA CE  ||  FE ED FA CF
          P      MBR      mbr
                 MsLZ     mslz          S Z D D 88 F0 ' 3 A
       M         Mub      mub           CA FE BA BE 00 00 00  ||  B9 FA F1 0E
                 NTFS     ntfs img      offset=3 N T F S 20 20 20 20 00
            E    PE       exe dll sys   M Z
         O       COFF     obj
            E    TE       te            V Z
                 Ppmd     pmd           8F AF AC 84
                 QCOW     qcow qcow2 qcow2c Q F I FB 00 00 00
                 Rpm      rpm           ED AB EE DB
                 Split    001
       M         SquashFS squashfs      h s q s  ||  s q s h  ||  s h s q  ||  q s h s
  C    M         SWFc     swf (~.swf)   C W S  ||  Z W S
   K             SWF      swf           F W S
      FM         UEFIc    scap          BD 86 f ; v 0D 0 @ B7 0E B5 Q 9E / C5 A0  ||  8B A6 < J # w FB H 80 = W 8C C1 FE C4 M  ||  B9 82 91 S B5 AB 91 C B6 9A E3 A9 C F7 / CC
      FM         UEFIf    uefif         offset=16 D9 T 93 z h 04 J D 81 CE 0B F6 17 D8 90 DF  ||  x E5 8C 8C = 8A 1C O 99 5 89 a 85 C3 - D3
                 VDI      vdi           offset=64 10 DA BE
        G        VHD      vhd           c o n e c t i x 00 00
                 VMDK     vmdk          K D M V
                 Xar      xar pkg xip   x a r ! 00 1C
  CK             xz       xz txz (.tar) FD 7 z X Z 00
                 Z        z taz (.tar)  1F 9D
  CK             zstd     zst tzstd (.tar) 0 x F D 2 F B 5 2 2 . . 2 8 00
  CK             lz4      lz4 tlz4 (.tar) 0 x 1 8 4 D 2 2 0 4 00
  C   F          7z       7z            7 z BC AF ' 1C
      F          Cab      cab           M S C F 00 00 00 00
                 Chm      chm chi chq chw I T S F 03 00 00 00 ` 00 00 00
      F          Hxs      hxs hxi hxr hxq hxw lit I T O L I T L S 01 00 00 00 ( 00 00 00
                 Iso      iso img       offset=32769 C D 0 0 1
      F G        Nsis     nsis          offset=4 EF BE AD DE N u l l s o f t I n s t
      F          Rar      rar r00       R a r ! 1A 07 00
      F          Rar5     rar r00       R a r ! 1A 07 01 00
  C      O   LH  tar      tar ova       offset=257 u s t a r
         O       Udf      udf iso img   offset=32768 01 C D 0 0 1
  C SN       LH  wim      wim swm esd ppkg M S W I M 00 00 00
  C   FMG        zip      zip z01 zipx jar xpi odt ods docx xlsx epub ipa apk appx P K 03 04  ||  P K 05 06  ||  P K 06 06  ||  P K 07 08 P K  ||  P K 0 0 P K

Codecs:
   4ED  303011B BCJ2
    ED  3030103 BCJ
    ED  3030205 PPC
    ED  3030401 IA64
    ED  3030501 ARM
    ED  3030701 ARMT
    ED  3030805 SPARC
    ED    20302 Swap2
    ED    20304 Swap4
    ED    40202 BZip2
    ED        0 Copy
    ED    40109 Deflate64
    ED    40108 Deflate
    ED        3 Delta
    ED       21 LZMA2
    ED    30101 LZMA
    ED    30401 PPMD
     D    40301 Rar1
     D    40302 Rar2
     D    40303 Rar3
     D    40305 Rar5
    ED  4F71101 ZSTD
    ED  4F71104 LZ4
    ED  6F10701 7zAES
    ED  6F00181 AES256CBC

Hashers:
      4        1 CRC32
     20      201 SHA1
     32        A SHA256
      8        4 CRC64
     32      202 BLAKE2sp

```

## Usage

- You can create `.7z` files, with [LZ4] [Fast LZMA2] [Brotli] [LZ5] [Lizard] and [Zstandard] method.
```
7z a archiv.7z -m0=zstd 
7z a archiv.7z -m0=zstd -mx3
7z a archiv.7z -m0=zstd -mx22 
7z a archiv.7z -m0=lz4 -mxN  ...
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
