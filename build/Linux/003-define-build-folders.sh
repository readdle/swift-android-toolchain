#!/bin/bash

cd $HOME

icu_libs=icu
swift_source=swift-source
swift_install=out/swift-android

mkdir -p $icu_libs
mkdir -p $swift_source
mkdir -p $swift_install

icu_libs=`realpath $icu_libs`
swift_source=`realpath $swift_source`
swift_install=`realpath $swift_install`

echo "export ICU_LIBS=$icu_libs" >> .build_env
echo "export DST_ROOT=$swift_install" >> .build_env
echo "export SWIFT_SRC=$swift_source" >> .build_env

echo "export FOUNDATION_DEPENDENCIES=\$HOME/foundation-dependencies" >> .build_env

echo "export DISPATCH_SRC=\$SWIFT_SRC/swift-corelibs-libdispatch" >> .build_env
echo "export FOUNDATION_SRC=\$SWIFT_SRC/swift-corelibs-foundation" >> .build_env
echo "export XCTEST_SRC=\$SWIFT_SRC/swift-corelibs-xctest" >> .build_env