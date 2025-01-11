#!/bin/bash
set -ex

source $HOME/.build_env

name=swift-android

out_bin=~/bin
mkdir -p $out_bin

cp -f $SWIFT_SRC/swiftpm/.build/release/swift-build $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/llvm-macosx-arm64/lib/libIndexStore.dylib $out_bin

rsync -av $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/bin/ $out_bin \
        --include swift \
        --include swift-autolink-extract \
        --include swift-stdlib-tool \
        --include swiftc \
        --include swift-frontend \
        --include swift-driver \
        --exclude '*'

pushd $HOME
    tar -cvf $name-bin.tar bin
popd
