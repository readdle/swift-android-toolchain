#!/bin/bash
set -ex

ROOT_DIR=$(realpath $(dirname $0))/../
SWIFT_VERSION="6.2"
BRANCH="release/$SWIFT_VERSION"

source $HOME/.build_env

pushd $SWIFT_SRC
    git clone https://github.com/apple/swift.git --branch $BRANCH --single-branch
    swift/utils/update-checkout --clone --scheme $BRANCH

    # Construct .swift.sum based on repositories that take part in release build
    echo "cmark-$(git -C ./cmark rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "llvm-project-$(git -C ./llvm-project rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "swift-$(git -C ./swift rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "swiftpm-$(git -C ./swiftpm rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "ninja-$(git -C ./ninja rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "llbuild-$(git -C ./llbuild rev-parse HEAD)" >> $ROOT_DIR/.swift.sum
    echo "NDK=$ANDROID_NDK_HOME" >> $ROOT_DIR/.swift.sum

    # Apply patches if exist
    for REPO in */; do
        if [ -d "$ROOT_DIR/patches/$REPO" ]; then
            pushd $REPO
                git apply $ROOT_DIR/patches/$REPO/*.patch
                echo "$(ls $ROOT_DIR/patches/$REPO)" >> $ROOT_DIR/.swift.sum
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

# Install swift for bootstraping
pushd $HOME
    curl -O https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz
    tar zxf swiftly-$(uname -m).tar.gz
    export SWIFTLY_HOME_DIR="/root/.local/share/swiftly"
    ./swiftly init --quiet-shell-followup
    . "$SWIFTLY_HOME_DIR/env.sh"
    hash -r

    swiftly install 6.2-snapshot
    swiftly use 6.2-snapshot

    # Export SWIFT_PATH
    TOOLCHAIN_NAME=$(jq -r '.inUse' "$SWIFTLY_HOME_DIR/config.json")
    echo "export SWIFT_PATH=\"$SWIFTLY_HOME_DIR/toolchains/$TOOLCHAIN_NAME/usr/bin\"" >> .build_env
popd
