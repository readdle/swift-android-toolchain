#!/bin/bash
set -ex

source $HOME/.build_env

$SWIFT_SRC/swift/utils/build-script \
    -R \
    --android \
    --android-ndk $ANDROID_NDK \
    --android-arch aarch64 \
    --android-api-level 29 \
    --stdlib-deployment-targets=android-aarch64 \
    --native-swift-tools-path=$SWIFT_PATH \
    --native-clang-tools-path=$SWIFT_PATH \
    --build-swift-tools=0 \
    --build-llvm=0 \
    --skip-build-cmark

mv $SWIFT_SRC/build/Ninja-ReleaseAssert/swift-linux-x86_64/lib $DST_ROOT/lib

# Move libraries to proper dst libs
mv $DST_ROOT/lib/swift/android/*.so $DST_ROOT/lib/swift/android/aarch64
mv $DST_ROOT/lib/swift/android/*.a $DST_ROOT/lib/swift/android/aarch64