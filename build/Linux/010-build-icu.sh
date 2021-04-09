#!/bin/bash
set -ex

source $HOME/.build_env

git clone https://github.com/readdle/libiconv-libicu-android.git $ICU_LIBS

export PATH=$ANDROID_NDK16:$PATH

pushd $ICU_LIBS
    git checkout swift-android-5.4-branch
    ./build-swift.sh
popd