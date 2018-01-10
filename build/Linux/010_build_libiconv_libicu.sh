#!/bin/bash

git clone https://github.com/SwiftAndroid/libiconv-libicu-android.git $LIBICONV_ANDROID

pushd $LIBICONV_ANDROID
    ./build.sh || {
        echo "$0 failed with code $?"
        exit 1
    }
popd