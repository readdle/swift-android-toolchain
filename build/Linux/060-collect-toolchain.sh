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
popd

# Move libIndexStore.dylib from bin to lib
mv $out_toolchain/usr/bin/libIndexStore.dylib $out_toolchain/usr/lib/libIndexStore.dylib

rsync -av shims/Darwin/ $out_toolchain
rsync -av src/tools/ $out

echo $toolchain_version > $out/VERSION

pushd $(dirname $out)
    zip -y -r $name.zip $name
popd

