#!/bin/bash
set -ex

source $HOME/.build_env

toolchain_version=`cat build/version`
name=swift-android

out=$HOME/out/$name
out_toolchain=$out/toolchain

mkdir -p $out
mkdir -p $out_toolchain
mkdir -p $out_toolchain/usr

input_libs=$HOME/lib

pushd $out
    # Copy platform libs
    rsync -av $input_libs $out_toolchain/usr --exclude 'lib/clang/13.0.0/lib'
popd

rsync -av shims/Darwin/ $out_toolchain
rsync -av src/tools/ $out

echo $toolchain_version > $out/VERSION

pushd $(dirname $out)
    zip -y -r $name.zip $name
popd

