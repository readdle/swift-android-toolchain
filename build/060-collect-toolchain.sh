#!/bin/bash
set -ex

source $HOME/.build_env

toolchain_version=`cat build/version`
name=swift-android

out=$HOME/out/$name
out_toolchain=$out/toolchain

mkdir -p $out
mkdir -p $out_toolchain

input_stdlib=$HOME/stdlib
input_lib=$HOME/lib

pushd $out
    # Copy NDK sysroot
    rsync -av $ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot/ $out_toolchain/

    # Create swift folder
    mkdir -p $out_toolchain/usr/lib/swift

    # Copy stlibs
    rsync -av $input_stdlib/swift-aarch64/swift/ $out_toolchain/usr/lib/swift/
    rsync -av $input_stdlib/swift-armv7/swift/ $out_toolchain/usr/lib/swift/
    rsync -av $input_stdlib/swift-x86_64/swift/ $out_toolchain/usr/lib/swift/
    rsync -av $input_stdlib/swift-i686/swift/ $out_toolchain/usr/lib/swift/
    
    # Copy corelibs
    rsync -av $input_lib/swift-aarch64/ $out_toolchain/usr/lib/swift/
    rsync -av $input_lib/swift-armv7/ $out_toolchain/usr/lib/swift/
    rsync -av $input_lib/swift-x86_64/ $out_toolchain/usr/lib/swift/
    rsync -av $input_lib/swift-i686/ $out_toolchain/usr/lib/swift/

    # Remove not supported Andorid version libs
    rm -rf $out_toolchain/usr/lib/*/21
    rm -rf $out_toolchain/usr/lib/*/22
    rm -rf $out_toolchain/usr/lib/*/23
    rm -rf $out_toolchain/usr/lib/*/24
    rm -rf $out_toolchain/usr/lib/*/25
    rm -rf $out_toolchain/usr/lib/*/26
    rm -rf $out_toolchain/usr/lib/*/27
    rm -rf $out_toolchain/usr/lib/*/28

    # Install swift android build tools
    git clone --depth 1 https://github.com/readdle/swift-android-buildtools.git --branch $toolchain_version build-tools
    pushd build-tools
        rm -rf .git .gitignore LICENSE
    popd
popd

echo $toolchain_version > $out/VERSION

pushd $(dirname $out)
    zip -y -r $name.zip $name
popd

