#!/bin/bash
set -ex

source $HOME/.build_env

toolchain_version=`cat build/config/version`
name=swift-android-$toolchain_version

out=$HOME/out/$name
out_toolchain=$out/toolchain

mkdir -p $out
mkdir -p $out_toolchain
mkdir -p $out_toolchain/usr

input_bin=$HOME/bin
input_libs=$HOME/lib

pushd $out

    # Copy bin from mac os toolchain
    rsync -av $input_bin $out_toolchain/usr

    # Copy platform libs
    rsync -av $input_libs $out_toolchain/usr --exclude 'lib/clang/10.0.0/lib'

    # Bundle NDK headers
    mkdir -p $out_toolchain/ndk-android-21/usr
    rsync -av $ANDROID_NDK/sysroot/usr/include $out_toolchain/ndk-android-21/usr

    # Patch Glibc module
    for swift_arch in aarch64 armv7 x86_64 i686
    do
        ls -la $out_toolchain/usr/lib/
        ls -la $out_toolchain/usr/lib/swift-$swift_arch/android/
        ls -la $out_toolchain/usr/lib/swift-$swift_arch/android/$swift_arch
        glibc_modulemap="$out_toolchain/usr/lib/swift-$swift_arch/android/$swift_arch/glibc.modulemap"

        if [[ ! -f "$glibc_modulemap.orig" ]]
        then
            cp "$glibc_modulemap" "$glibc_modulemap.orig"
        fi

        sed -e 's@/home/runner/android-ndk-r21e/toolchains/llvm/prebuilt/linux-x86_64/sysroot@../../../../../ndk-android-21@' < "$glibc_modulemap.orig" > "$glibc_modulemap"
    done
popd

# Move libIndexStore.dylib from bin to lib
mv $out_toolchain/usr/bin/libIndexStore.dylib $out_toolchain/usr/lib/libIndexStore.dylib

rsync -av shims/Darwin/ $out_toolchain
rsync -av src/tools/ $out

echo $toolchain_version > $out/VERSION

pushd $(dirname $out)
    zip -y -r $name.zip $name
popd

