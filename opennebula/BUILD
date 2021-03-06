#!/bin/sh

set -e

PKG=opennebula
VER=1.4.0
MAJORVER=1.4
PKGVER=1
OS=`tpkg --qenv | grep 'Operating System' | awk '{print $NF}'`
if echo $OS | egrep 'RedHat|CentOS'
then
        # Save folks from having to build separate packages for Red Hat and
        # CentOS
        OSMAJOR=`echo $OS | cut -d- -f2`
        OS="RedHat-$OSMAJOR,CentOS-$OSMAJOR"
fi
ARCH=`tpkg --qenv | grep 'Architecture' | awk '{print $NF}'`

for tpkg in scons sqlite xmlrpc-c
do
	tpkg --quiet -q $tpkg || tpkg --no-prompt -i $tpkg
done

# Make sure configure finds the tpkg xmlrpc-c-config instead of others
PATH=/opt/tpkg/bin:$PATH
export PATH

#rm -rf $PKG-$VER
rm -rf one-$MAJORVER
#tar zxvf $PKG-$VER.tar.gz
tar zxvf one-$VER.tar.gz
#cd $PKG-$VER
cd one-$MAJORVER
scons sqlite=/opt/tpkg
pkgdir=`mktemp -d -t tpkg.XXXXXX`
# List of dependencies from
# http://www.opennebula.org/documentation:rel1.4:notes
cat ../../tpkg.xml | \
	sed "s/NAME/$PKG/" | \
	sed "s/VERSION/$VER/" | \
	sed "s/PKGVER/$PKGVER/" | \
	sed "s/OS/$OS/" | \
	sed "s/ARCH/$ARCH/" | \
        sed '/<files>/i\
<dependencies><dependency><name>ruby</name></dependency><dependency><name>gem-nokogiri</name></dependency><dependency><name>gem-rake</name></dependency><dependency><name>gem-xmlparser</name></dependency><dependency><name>sqlite</name></dependency><dependency><name>xmlrpc-c</name></dependency></dependencies>' | \
        sed '/<files>/i\
<externals><external><name>user</name><data>oneadmin</data></external></externals>' | \
        sed '/<files>/a\
<file><path>/opt/tpkg/etc/init.d/opennebula</path><init/></file>' | \
        sed "/<files>/a\\
<file><path>/opt/tpkg/$PKG-$VER/var</path><posix><owner>oneadmin</owner></posix></file>" \
	> $pkgdir/tpkg.xml
mkdir -p $pkgdir/root/opt/tpkg/$PKG-$VER
# Add init script
mkdir -p $pkgdir/root/opt/tpkg/etc/init.d
sed "s,%ONE_LOCATION%,/opt/tpkg/$PKG-$VER," ../$PKG.init > $pkgdir/root/opt/tpkg/etc/init.d/$PKG
chmod 755 $pkgdir/root/opt/tpkg/etc/init.d/$PKG
# Add profile.d file
mkdir -p $pkgdir/root/opt/tpkg/etc/profile.d
sed "s,%ONE_LOCATION%,/opt/tpkg/$PKG-$VER," ../$PKG.profile > $pkgdir/root/opt/tpkg/etc/profile.d/$PKG
chmod 755 $pkgdir/root/opt/tpkg/etc/profile.d/$PKG
# Install
DESTDIR=$pkgdir/root ./install.sh -d /opt/tpkg/$PKG-$VER
# Make package
tpkg --make $pkgdir
# Cleanup
rm -rf $pkgdir
cd ..
#rm -rf $PKG-$VER
rm -rf one-$MAJORVER

