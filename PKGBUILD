# This is an example PKGBUILD file. Use this as a start to creating your own,
# and remove these comments. For more information, see 'man PKGBUILD'.
# NOTE: Please fill out the license field for your package! If it is unknown,
# then please put 'unknown'.

# Maintainer: Your Name <youremail@domain.com>
gtkver=2
pkgname=libitmages-gtk${gtkver}
pkgver=1.20
pkgrel=16
pkgdesc="GUI library for ITmages uploader"
arch=(i686 x86_64)
license=('LGPL')
groups=("gnome")
depends=("itmages-service" "libgexiv2")
makedepends=("gtk${gtkver}" "cmake" "vala" "make" "libgexiv2")
install="libitmages.install"

build() {
  cd ${startdir}
  rm -rf ${srcdir}/libitmages
  mkdir -p ${srcdir}/libitmages
  cp -r ../{nautilus,cmake,data,src,bin,pixmaps,po,CMakeLists.txt,config.h.cmake,libitmages.pc.cmake,include,vapi,icons,VERSION} ${srcdir}/libitmages || return 1
  cd ${srcdir}/libitmages
  cmake -DGTKVER=${gtkver}.0 CMakeLists.txt || return 1
  make || return 1
}

package() {
  cd ${srcdir}/libitmages
  make DESTDIR="$pkgdir/" install
  VER=`grep -m1 "pkgrel=" ${startdir}/PKGBUILD | awk -F"=" '{print $2}'`
  let "VER++"
  sed -i "s/^pkgrel=.*/pkgrel=$VER/" ${startdir}/PKGBUILD
}

# vim:set ts=2 sw=2 et:
