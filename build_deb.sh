#!/bin/bash
set -e

PACKAGE_NAME="brainworkshop"
VERSION="4.8.4"
ARCH="all"
MAINTAINER="Paul Hoskinson <plhosk@gmail.com>"
DESCRIPTION="Brain Workshop - Dual N-Back mental exercise"
DEPENDS="python2"

# Create build directory
BUILD_DIR="build_deb"
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/DEBIAN

# Create control file
cat > $BUILD_DIR/DEBIAN/control << EOF
Package: $PACKAGE_NAME
Version: $VERSION
Section: games
Priority: optional
Architecture: $ARCH
Depends: $DEPENDS
Maintainer: $MAINTAINER
Description: $DESCRIPTION
 Brain Workshop is a free open-source version of the Dual N-Back
 mental exercise.
EOF

# Run make install to the build directory
make install DESTDIR=$PWD/$BUILD_DIR PREFIX=/usr

# Build the package
dpkg-deb --build $BUILD_DIR ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb

echo "Package created: ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
