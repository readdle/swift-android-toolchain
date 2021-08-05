#!/bin/bash
set -ex

source $HOME/.build_env

name=swift-android-5.4

out_bin=~/bin
mkdir -p $out_bin

cp -f /usr/local/bin/pkg-config $out_bin
cp -f /usr/local/bin/ninja $out_bin

cp -f $SWIFT_SRC/swiftpm/.build/release/swift-build $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/llvm-macosx-x86_64/lib/libIndexStore.dylib $out_bin

rsync -av $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-x86_64/bin/ $out_bin \
        --include swift \
        --include swift-autolink-extract \
        --include swift-stdlib-tool \
        --include swiftc \
        --include swift-frontend \
        --exclude '*'

pushd $HOME
    tar -cvf $name-bin.tar bin
popd
