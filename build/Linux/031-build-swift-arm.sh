#!/bin/bash
set -ex

source $HOME/.build_env

$SWIFT_SRC/swift/utils/build-script --preset buildbot_linux_crosscompile_android,no_test,tools=RA,stdlib=RD,build,armv7 \
    ndk_path=$ANDROID_NDK17 \
    icu_dir=$ICU_LIBS/armeabi-v7a \
    install_destdir=$DST_ROOT/swift-nightly-install \
    installable_package=$DST_ROOT/swift-android-5.0.tar.gz