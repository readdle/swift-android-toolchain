#!/bin/bash
set -e

git clone https://github.com/readdle/libiconv-libicu-android.git $LIBICONV_ANDROID

pushd $LIBICONV_ANDROID
    git checkout swift-android-4.0
    ./build.sh
popd
