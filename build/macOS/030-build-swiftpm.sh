#!/bin/bash
set -ex

source $HOME/.build_env

unset TOOLCHAINS

pushd $SWIFT_SRC/swiftpm
    swift build --configuration release --product swift-build
popd