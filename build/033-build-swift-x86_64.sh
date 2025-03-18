#!/bin/bash
set -ex

source $HOME/.build_env

$SWIFT_SRC/swift/utils/build-script \
    -R \
    --android \
    --android-ndk $ANDROID_NDK \
    --android-arch x86_64 \
    --android-api-level 21 \
    --stdlib-deployment-targets=android-x86_64 \
    --native-swift-tools-path=$SWIFT_PATH \
    --native-clang-tools-path=$SWIFT_PATH \
    --build-swift-tools=0 \
    --build-llvm=0 \
    --skip-build-cmark

mv $SWIFT_SRC/build/Ninja-ReleaseAssert/swift-linux-x86_64/lib $DST_ROOT/lib