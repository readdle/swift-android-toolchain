#!/bin/bash
set -ex

unset TOOLCHAINS
xcode_toolchain=$(dirname dirname $(dirname $(dirname $(xcrun --find swift))))

name=swift-android-5.0

out=out/$name
out_toolchain=$out/toolchain
out_bin=$out_toolchain/usr/bin

mkdir -p $out
mkdir -p $out_toolchain
mkdir -p $out_bin

out=`realpath $out`
out_toolchain=`realpath $out_toolchain`
out_bin=`realpath $out_bin`
linux_out=`realpath vagrant/out`

pushd $linux_out
    mkdir -p usr/bin
    mkdir -p ndk-android-21

    rsync -av swift-nightly-install/ $out_toolchain \
        --include '/usr/lib/' \
        --include '/usr/lib/clang/***' \
        --include '/usr/lib/swift/***' \
        --exclude '/usr/lib/swift/linux' \
        --exclude '/usr/lib/swift/migrator' \
        --exclude '/usr/**'

    cp /usr/local/bin/pkg-config $out_bin
    cp /usr/local/bin/ninja $out_bin

    rsync -av swift-source/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-x86_64/bin/ $out_bin \
        --include swift \
        --include swift-autolink-extract \
        --include swift-format \
        --include swift-stdlib-tool \
        --include swift-build-tool \
        --include swiftc \
        --exclude '*'

    cp swift-source/swiftpm/.build/x86_64-apple-macosx10.10/release/swift-build $out_bin
    cp -r $xcode_toolchain/usr/lib/swift/pm $out_toolchain/usr/lib/swift
    cp -r $xcode_toolchain/usr/lib/swift/macosx $out_toolchain/usr/lib/swift

    cp -r $ANDROID_NDK_HOME/sysroot ndk-android-21

    for arch in $out_toolchain/usr/lib/swift/android/*
    do 
        glibc_modulemap="$arch/glibc.modulemap"
        if [[ ! -f "$glibc_modulemap.orig" ]]; then
            cp "$glibc_modulemap" "$glibc_modulemap.orig"
        fi &&
      
        sed -e 's@/home/vagrant/android-ndk-r17c/sysroot@../../../../../ndk-android-21/sysroot@' < "$glibc_modulemap.orig" > "$glibc_modulemap"
    done
popd

rsync -av shims/`uname`/ $out_toolchain
rsync -av src/tools/ $out

pushd $(dirname $out)
    zip -r $name.zip $name
popd

