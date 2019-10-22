#!/bin/bash
set -ex

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

pushd $BASE_DIR
    build/macOS/010-build-swift.sh
    build/macOS/020-build-swiftpm.sh
    build/macOS/030-collect-toolchain.sh
popd
