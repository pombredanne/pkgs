#!/bin/bash
set -e
set -u
set -o pipefail

PKG=socat
VER=1.7.1.1
PKGVER=1
prefix=/opt/tpkg
OSMAJOR=`facter | grep lsbmajdistrelease | cut -d' ' -f3`
ARCH=`facter hardwaremodel`

rm -rf $PKG-$VER
tar zxf $PKG-$VER.tar.gz
cd $PKG-$VER

for i in readline-devel openssl-devel tcp_wrappers
do
	rpm --quiet -q $i || sudo yum install -y $i
done

./configure --prefix=$prefix
make -j4
pkgdir=`mktemp -d -t tpkg.XXXXXX`
sed -e "s/NAME/$PKG/" \
	-e "s/VERSION/$VER/" \
	-e "s/PKGVER/$PKGVER/" \
	-e "s/OS/RedHat-$OSMAJOR,CentOS-$OSMAJOR/" \
	-e "s/ARCH/$ARCH/" < ../../tpkg.xml > $pkgdir/tpkg.xml

mkdir -p $pkgdir/root$prefix
make install DESTDIR=$pkgdir/root

# Make package
tpkg --make $pkgdir || exit 1
# Cleanup
rm -rf $pkgdir
cd ..
rm -rf $PKG-$VER
