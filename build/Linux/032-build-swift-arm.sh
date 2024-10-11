#!/bin/bash
set -ex

source $HOME/.build_env

$SWIFT_SRC/swift/utils/build-script \
    -R \
    --android \
    --android-ndk $ANDROID_NDK \
    --android-arch armv7 \
    --android-api-level 21 \
    --stdlib-deployment-targets=android-armv7 \
    --native-swift-tools-path=$SWIFT_PATH \
    --native-clang-tools-path=$SWIFT_PATH \
    --build-swift-tools=0 \
    --build-llvm=0 \
    --skip-build-cmark \
    install_destdir=$DST_ROOT/swift-nightly-install \
    installable_package=$DST_ROOT/swift-android.tar.gz 

mv $DST_ROOT/swift-nightly-install/usr/lib/swift $DST_ROOT/swift-nightly-install/usr/lib/swift-armv7
rm -rf $SWIFT_SRC/build/buildbot_linux/swift-linux-x86_64/stdlib