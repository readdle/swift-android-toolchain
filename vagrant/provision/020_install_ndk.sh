#!/bin/bash

for version in 16b 21e
do
    ndk=android-ndk-r$version
    ndk_zip=$ndk-linux-x86_64.zip

    wget --progress=bar:force https://dl.google.com/android/repository/$ndk_zip

    unzip $ndk_zip -x \
        "$ndk/toolchains/mips64el-linux-android-4.9*" \
        "$ndk/toolchains/mipsel-linux-android-4.9*" \
        \
        "$ndk/platforms/android-9*" \
        "$ndk/platforms/android-12*" \
        "$ndk/platforms/android-13*" \
        "$ndk/platforms/android-14*" \
        "$ndk/platforms/android-15*" \
        "$ndk/platforms/android-16*" \
        "$ndk/platforms/android-17*" \
        "$ndk/platforms/android-18*" \
        "$ndk/platforms/android-19*" \
        "$ndk/platforms/android-22*" \
        "$ndk/platforms/android-23*" \
        "$ndk/platforms/android-24*" \
        "$ndk/platforms/android-25*" \
        "$ndk/platforms/android-26*" \
        "$ndk/platforms/android-27*" \
        "$ndk/platforms/android-28*" \
        "$ndk/platforms/android-29*" \
        "$ndk/platforms/android-30*" > /dev/null

    rm $ndk_zip
done

# exports
echo "export ANDROID_NDK16=\$HOME/android-ndk-r16b" >> .build_env
echo "export ANDROID_NDK21=\$HOME/android-ndk-r21e" >> .build_env
echo "export ANDROID_NDK=\$ANDROID_NDK21" >> .build_env