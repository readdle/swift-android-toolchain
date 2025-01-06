#!/bin/bash
set -ex

ROOT_DIR=$(realpath $(dirname $0))/../../
BRANCH="release/6.0"

source $HOME/.build_env

pushd $SWIFT_SRC
    git clone https://github.com/apple/swift.git --branch $BRANCH --single-branch
    swift/utils/update-checkout --clone --scheme $BRANCH

    # Construct .swift.sum based on repositories that take part in release build
    echo "cmark-$(git -C ./cmark rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "llvm-project-$(git -C ./llvm-project rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "swift-$(git -C ./swift rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "swiftpm-$(git -C ./swiftpm rev-parse HEAD)" >> $ROOT_DIR/.swift.sum

    # Apply patches if exist
    for REPO in */; do
        if [ -d "$ROOT_DIR/patches/$REPO" ]; then
            pushd $REPO
                git apply $ROOT_DIR/patches/$REPO/*.patch
                echo "$(ls $ROOT_DIR/patches/$REPO)" >> $ROOT_DIR/.swift.sum
            popd
        fi
    done

popd
