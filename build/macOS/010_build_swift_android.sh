#!/bin/bash

BASE_DIR=`pwd`

export ANDROID_NDK_HOME=$BASE_DIR/vagrant/out/ndk
export SWIFT_SOURCE=$BASE_DIR/vagrant/out/swift-source
export SWIFT_INSTALL=$BASE_DIR/vagrant/out/swift-install
export LIBICONV_ANDROID=$BASE_DIR/vagrant/out/libiconv-libicu-android

build/Linux/030_build_swift_android.sh