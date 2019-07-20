#!/bin/bash
set -ex

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

pushd $BASE_DIR
    build/macOS/build-swift.sh
    build/macOS/build-swiftpm.sh
    build/macOS/collect-toolchain.sh
popd
