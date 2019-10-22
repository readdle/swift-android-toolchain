#!/bin/bash
set -ex

source $HOME/.build_env

pushd $SWIFT_SRC
    git clone https://github.com/readdle/swift.git --branch swift-android-5.0-branch
    swift/utils/update-checkout --clone --scheme swift-android-5.0-branch
popd