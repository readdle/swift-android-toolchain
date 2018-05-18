#!/bin/bash

git clone https://github.com/readdle/libiconv-libicu-android.git $LIBICONV_ANDROID

pushd $LIBICONV_ANDROID
    git checkout swift-android-4.0
    ./build.sh || {
        echo "$0 failed with code $?"
        exit 1
    }
popd
