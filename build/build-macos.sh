#!/bin/bash
set -ex

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

pushd $BASE_DIR
    build/macOS/000-install-dependencies.sh
    build/macOS/010-clone-swift.sh
    build/macOS/020-build-swift.sh
    build/macOS/030-build-swiftpm.sh
    build/macOS/040-collect-toolchain-bin.sh
popd
