#!/bin/bash

cd $HOME

mkdir -p ./swift-source
mkdir -p ./out/swift-android

swift_source="~/swift-source"
swift_install="~/out/swift-android"

echo "export DST_ROOT=$swift_install" >> .build_env
echo "export SWIFT_SRC=$swift_source" >> .build_env

echo "export ICU_LIBS=~/icu" >> .build_env
echo "export OPENSSL_LIBS=~/openssl" >> .build_env
echo "export CURL_LIBS=~/curl" >> .build_env
echo "export LIBXML_LIBS=~/libxml" >> .build_env

echo "export DISPATCH_SRC=\$SWIFT_SRC/swift-corelibs-libdispatch" >> .build_env
echo "export FOUNDATION_SRC=\$SWIFT_SRC/swift-corelibs-foundation" >> .build_env
echo "export XCTEST_SRC=\$SWIFT_SRC/swift-corelibs-xctest" >> .build_env