#!/bin/bash

if [[ `uname` == 'Linux' ]]
then
    sudo unlink /usr/bin/armv7-none-linux-android-ld.gold
    sudo unlink /usr/bin/armv7-none-linux-androideabi-ld.gold
fi

pushd $SWIFT_SOURCE/swift
    utils/build-script \
        --release \
        --assertions \
        --no-swift-stdlib-assertions \
        --android \
        --android-ndk $ANDROID_NDK_HOME \
        --android-api-level 21 \
        --android-icu-uc $LIBICONV_ANDROID/armeabi-v7a \
        --android-icu-uc-include $LIBICONV_ANDROID/armeabi-v7a/icu/source/common \
        --android-icu-i18n $LIBICONV_ANDROID/armeabi-v7a \
        --android-icu-i18n-include $LIBICONV_ANDROID/armeabi-v7a/icu/source/i18n \
        --install-swift \
        '--swift-install-components=compiler;clang-builtin-headers;stdlib;sdk-overlay' \
        --install-prefix=/usr --install-destdir=$SWIFT_INSTALL || {

            echo "$0 failed with code $?"
            exit 1
        }
popd

# android linkers should be set after swift is built but not earlier
if [[ `uname` == 'Linux' ]]
then
    sudo ln -s $ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ld.gold /usr/bin/armv7-none-linux-android-ld.gold
    sudo ln -s $ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ld.gold /usr/bin/armv7-none-linux-androideabi-ld.gold
fi
