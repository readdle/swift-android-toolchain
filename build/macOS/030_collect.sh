#!/bin/bash

TOOLCHAIN_VERSION=`cat build/config/version`
NAME=swift-android-$TOOLCHAIN_VERSION

OUT=out/$NAME
OUT_TOOLCHAIN=$OUT/toolchain
OUT_BIN=$OUT_TOOLCHAIN/usr/bin

mkdir -p $OUT
mkdir -p $OUT_TOOLCHAIN
mkdir -p $OUT_BIN

OUT=`realpath $OUT`
OUT_TOOLCHAIN=`realpath $OUT_TOOLCHAIN`
OUT_BIN=`realpath $OUT_BIN`
LINUX_OUT=`realpath vagrant/out`

pushd $LINUX_OUT
    rsync -av swift-install/ $OUT_TOOLCHAIN \
        --include '/usr/lib/' \
        --include '/usr/lib/swift/***' \
        --exclude '/usr/lib/swift/clang/lib' \
        --exclude '/usr/lib/swift/linux' \
        --exclude '/usr/lib/swift/migrator' \
        --exclude '/usr/**' 
        

    pushd $ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/
        cp arm-linux-androideabi/bin/ld.gold $OUT_BIN
        cp lib/gcc/arm-linux-androideabi/4.9.x/armv7-a/libgcc.a $OUT_BIN
    
        cp /usr/local/bin/pkg-config $OUT_BIN
        cp /usr/local/bin/ninja $OUT_BIN
    popd

    cp swift-source/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-x86_64/bin/swiftc $OUT_BIN
    cp swift-source/swiftpm/.build/x86_64-apple-macosx10.10/release/swift-build $OUT_BIN
popd

rsync -av shims/`uname`/ $OUT_TOOLCHAIN

GLIBC_MODULEMAP="$OUT_TOOLCHAIN/usr/lib/swift/android/armv7/glibc.modulemap"
if [[ ! -f "$GLIBC_MODULEMAP.orig" ]]; then
    cp "$GLIBC_MODULEMAP" "$GLIBC_MODULEMAP.orig"
fi &&
  
sed -e 's@".*/android-21/arch-arm@"../../../../../ndk-android-21@' < "$GLIBC_MODULEMAP.orig" > "$GLIBC_MODULEMAP"

rsync -av src/tools/ $OUT
echo $TOOLCHAIN_VERSION > $OUT/VERSION

pushd $(dirname $OUT)
    zip -r $NAME.zip $NAME
popd
