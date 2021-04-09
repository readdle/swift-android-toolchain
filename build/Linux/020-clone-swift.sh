#!/bin/bash
set -ex

source $HOME/.build_env

pushd $SWIFT_SRC
    git clone https://github.com/readdle/swift.git --branch readdle/release/5.4
    swift/utils/update-checkout --clone --scheme readdle/release/5.4
popd