#!/bin/bash

NDK=android-ndk-r14b
NDK_ZIP=$NDK-linux-x86_64.zip

wget --progress=bar:force https://dl.google.com/android/repository/$NDK_ZIP

unzip $NDK_ZIP -x \
    "$NDK/toolchains/aarch64-linux-android-4.9*" \
    "$NDK/toolchains/mips64el-linux-android-4.9*" \
    "$NDK/toolchains/mipsel-linux-android-4.9*" \
    "$NDK/toolchains/x86-4.9*" \
    "$NDK/toolchains/x86_64-4.9*" \
    \
    "$NDK/platforms/android-9*" \
    "$NDK/platforms/android-12*" \
    "$NDK/platforms/android-13*" \
    "$NDK/platforms/android-15*" \
    "$NDK/platforms/android-17*" \
    "$NDK/platforms/android-18*" \
    "$NDK/platforms/android-19*" \
    "$NDK/platforms/android-22*" \
    "$NDK/platforms/android-23*" \
    "$NDK/platforms/android-24*" > /dev/null

rm $NDK_ZIP

# Create Android toolchain
STANDALON_TOOLCHAIN=android-standalone-toolchain
$NDK/build/tools/make_standalone_toolchain.py --api 21 --arch arm --stl libc++ --install-dir $STANDALON_TOOLCHAIN --force -v

# exports
NDK=`realpath $NDK`
STANDALONE_TOOLCHAIN=`realpath $STANDALON_TOOLCHAIN`

echo "export ANDROID_NDK=$NDK" >> .profile
echo "export STANDALONE_TOOLCHAIN=$STANDALONE_TOOLCHAIN" >> .profile
echo "export PATH=\$ANDROID_NDK:\$PATH" >> .profile