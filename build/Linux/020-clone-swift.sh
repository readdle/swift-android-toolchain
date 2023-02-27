#!/bin/bash
set -ex

ROOT_DIR=$(realpath $(dirname $0))/../../
BRANCH="release/5.7"

source $HOME/.build_env

pushd $SWIFT_SRC
    git clone https://github.com/apple/swift.git --branch $BRANCH --single-branch
    swift/utils/update-checkout --clone --scheme $BRANCH

    # Replace Apple foundation with Readdle's fork
    rm -rf swift-corelibs-foundation
    git clone https://github.com/readdle/swift-corelibs-foundation.git --branch readdle/$BRANCH --single-branch

    # Construct .swift.sum based on repositories that take part in release build
    echo "cmark-$(git -C ./cmark rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "llvm-project-$(git -C ./llvm-project rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "swift-$(git -C ./swift rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "swiftpm-$(git -C ./swiftpm rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "ninja-$(git -C ./ninja rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "llbuild-$(git -C ./llbuild rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "NDK=$ANDROID_NDK_HOME" >> $ROOT_DIR/.swift.sum

    # Apply patches for $BRANCH if exist
    for REPO in */; do
        if [ -d "$ROOT_DIR/patches/$BRANCH/$REPO" ]; then
            pushd $REPO
                git apply $ROOT_DIR/patches/$BRANCH/$REPO/*.patch
                echo "$(ls $ROOT_DIR/patches/$BRANCH/$REPO)" >> $ROOT_DIR/.swift.sum
            popd
        fi
    done

    # Try to keep sources as small as possible
    rm -rf llbuild/.git
    rm -rf cmark/.git
    rm -rf llvm-project/.git
    rm -rf swift/.git
    rm -rf swiftpm/.git
    rm -rf ninja/.git

popd
