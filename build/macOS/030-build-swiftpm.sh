#!/bin/bash
set -ex

source $HOME/.build_env

export SKIP_XCODE_VERSION_CHECK=1
unset TOOLCHAINS

pushd $SWIFT_SRC/swiftpm
    swift build --configuration release --product swift-build
popd