#!/bin/bash
set -e

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
