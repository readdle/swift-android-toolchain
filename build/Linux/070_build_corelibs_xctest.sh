#!/bin/bash

module_name=XCTest
build_dir=$SWIFT_BUILD/xctest-linux-x86_64

mkdir -p $build_dir

pushd $SWIFT_SOURCE/swift-corelibs-xctest
    # all this -I/-L needed because dispatch and foundation not finally installed yet
    $SWIFT_BUILD/swift-linux-x86_64/bin/swiftc -v \
        -target armv7-none-linux-androideabi \
        -sdk $ANDROID_NDK_HOME/platforms/android-21/arch-arm \
        -L $ANDROID_NDK_HOME/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a \
        -L $ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x \
        \
        -I $SWIFT_SOURCE/swift-corelibs-libdispatch \
        -I $SWIFT_SOURCE/swift-corelibs-libdispatch/src/swift \
        -I $SWIFT_BUILD/foundation-linux-x86_64/Foundation \
        -I $SWIFT_BUILD/foundation-linux-x86_64/Foundation/usr/lib/swift \
        -L $SWIFT_BUILD/foundation-linux-x86_64/Foundation/ \
        -L $SWIFT_INSTALL/usr/lib/swift/android/ \
        \
        -emit-module -emit-module-path "$build_dir/$module_name.swiftmodule" \
        -module-name $module_name -module-link-name $module_name \
        \
        -emit-library -o "$build_dir/lib$module_name.so" \
        -Xlinker -soname=lib$module_name.so \
        `find Sources -name '*.swift'`

    exit_code=$?
popd

exit $exit_code