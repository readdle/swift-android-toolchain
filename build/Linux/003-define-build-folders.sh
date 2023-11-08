#!/bin/bash

cd $HOME

swift_source=swift-source
swift_install=out/swift-android

mkdir -p $swift_source
mkdir -p $swift_install

swift_source=`realpath $swift_source`
swift_install=`realpath $swift_install`

echo "export DST_ROOT=$swift_install" >> .build_env
echo "export SWIFT_SRC=$swift_source" >> .build_env

echo "export ICU_LIBS=\$HOME/icu" >> .build_env
echo "export OPENSSL_LIBS=\$HOME/openssl" >> .build_env
echo "export CURL_LIBS=\$HOME/curl" >> .build_env
echo "export LIBXML_LIBS=\$HOME/libxml" >> .build_env

echo "export DISPATCH_SRC=\$SWIFT_SRC/swift-corelibs-libdispatch" >> .build_env
echo "export FOUNDATION_SRC=\$SWIFT_SRC/swift-corelibs-foundation" >> .build_env
echo "export XCTEST_SRC=\$SWIFT_SRC/swift-corelibs-xctest" >> .build_env