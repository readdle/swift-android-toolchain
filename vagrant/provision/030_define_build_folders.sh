#!/bin/bash

LIBICONV_ANDROID=libiconv-libicu-android
SWIFT_SOURCE=swift-source
SWIFT_INSTALL=swift-install

mkdir $LIBICONV_ANDROID
mkdir $SWIFT_SOURCE
mkdir $SWIFT_INSTALL

LIBICONV_ANDROID=`realpath $LIBICONV_ANDROID`
SWIFT_SOURCE=`realpath $SWIFT_SOURCE`
SWIFT_INSTALL=`realpath $SWIFT_INSTALL`

echo "export LIBICONV_ANDROID=$LIBICONV_ANDROID" >> .profile
echo "export SWIFT_SOURCE=$SWIFT_SOURCE" >> .profile
echo "export SWIFT_BUILD=\$SWIFT_SOURCE/build/Ninja-ReleaseAssert+stdlib-Release" >> .profile
echo "export SWIFT_INSTALL=$SWIFT_INSTALL" >> .profile
