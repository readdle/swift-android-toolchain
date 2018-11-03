#!/bin/bash
set -ex

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

pushd $BASE_DIR
    build/macOS/010_build_swift_android.sh
    build/macOS/020_build_swiftpm.sh
    build/macOS/030_collect.sh
popd
