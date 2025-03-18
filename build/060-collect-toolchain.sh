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
    rsync -av $input_libs $out_toolchain/usr --exclude 'lib/clang/17/lib'

    git clone --depth 1 https://github.com/readdle/swift-android-buildtools.git --branch $toolchain_version build-tools
    pushd build-tools
        rm -rf .git .gitignore LICENSE
    popd
popd

echo $toolchain_version > $out/VERSION

pushd $(dirname $out)
    zip -y -r $name.zip $name
popd

