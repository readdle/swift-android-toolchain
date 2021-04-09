#!/bin/bash
set -ex

source $HOME/.build_env

$SWIFT_SRC/swift/utils/build-script --preset buildbot_linux_crosscompile_android,tools=RA,stdlib=RD,build,aarch64 \
    ndk_path=$ANDROID_NDK \
    icu_dir=$ICU_LIBS/arm64-v8a \
    install_destdir=$DST_ROOT/swift-nightly-install \
    installable_package=$DST_ROOT/swift-android-5.4.tar.gz

mv $DST_ROOT/swift-nightly-install/usr/lib/swift $DST_ROOT/swift-nightly-install/usr/lib/swift-aarch64