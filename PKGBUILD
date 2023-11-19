# Maintainer: Taiki Sugawara <buzz.taiki@gmail.com>
# Contributor: Evangelos Foutras <evangelos@foutrelis.com>
# Contributor: Gaetan Bisson <bisson@archlinux.org>
# Contributor: Thayer Williams <thayer@archlinux.org>
# Contributor: Hugo Doria <hugo@archlinux.org>
# Contributor: TuxSpirit<tuxspirit@archlinux.fr>
# Contributor: Daniel J Griffiths <ghost1227@archlinux.us>

pkgname=p7zip-full-bin
_pkgname=p7zip-full
pkgver=23.01
pkgrel=1
_upstream_pkgrel=3
pkgdesc="Command-line file archiver with high compression ratio, based on libnatspec patch from ubuntu zip-i18n PPA (https://launchpad.net/~frol/+archive/zip-i18n)."
arch=('x86_64')
url="https://github.com/phoepsilonix/p7zip-full"
license=('LGPL' 'custom:unRAR')
depends=('gcc-libs' 'sh')
makedepends=('mold')
conflicts=('p7zip')
provides=('p7zip')
source=(https://github.com/phoepsilonix/p7zip-full/archive/refs/tags/v$pkgver.$_upstream_pkgrel.tar.gz)
sha256sums=('570b3f787fa15527805aa28268223f52cf1292cf2529675cae9a5717a34ed17f')

prepare() {
  cd $_pkgname-$pkgver.$_upstream_pkgrel

  # Leave man page compression to makepkg to maintain reproducibility
}

build() {
  cd $_pkgname-$pkgver.$_upstream_pkgrel
export PATH="$HOME/.local/bin:$PATH"
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
export LDFLAGS_ADD="-fuse-ld=${LD/ld./} -Wl,-s -Wno-error=unused-command-line-argument"
export CFLAGS_ADD="${CFLAGS_ADD} -DZ7_AFFINITY_DISABLE"

ARTIFACTS_DIR=bin/p7zip/
mkdir -p ${ARTIFACTS_DIR}
export MACFLAGS=""
make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/Alone2 -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Bundles/Alone2/b/${OUTDIR}/7zz ${ARTIFACTS_DIR}
make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc mkdir && make -C CPP/7zip/Bundles/SFXCon -f makefile.gcc CFLAGS_ADDITIONAL="${CFLAGS_ADDITIONAL}" ${FLAGS} -j
cp CPP/7zip/Bundles/SFXCon/b/${OUTDIR}/7zCon.sfx ${ARTIFACTS_DIR}
}

package() {
  cd $_pkgname-$pkgver

  make install \
    DEST_DIR="$pkgdir" \
    DEST_HOME=/usr \
    DEST_MAN=/usr/share/man

  # Remove documentation for the GUI file manager
  rm -r "$pkgdir/usr/share/doc/p7zip/DOC/MANUAL/fm"

  install -d "${pkgdir}"/usr/share/licenses/p7zip
  ln -s -t "$pkgdir/usr/share/licenses/p7zip/" \
    /usr/share/doc/p7zip/DOC/License.txt \
    /usr/share/doc/p7zip/DOC/unRarLicense.txt
}

# vim:set ts=2 sw=2 et:
