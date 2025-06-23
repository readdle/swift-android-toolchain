#!/bin/bash
set -ex

ROOT_DIR=$(realpath $(dirname $0))/../
SWIFT_VERSION="6.1"
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
    wget https://download.swift.org/swift-$SWIFT_VERSION-release/ubuntu2404/swift-$SWIFT_VERSION-RELEASE/swift-$SWIFT_VERSION-RELEASE-ubuntu24.04.tar.gz
    tar -xvzf swift-$SWIFT_VERSION-RELEASE-ubuntu24.04.tar.gz
    rm swift-$SWIFT_VERSION-RELEASE-ubuntu24.04.tar.gz
    mv $HOME/swift-$SWIFT_VERSION-RELEASE-ubuntu24.04 $HOME/swift-toolchain
    export PATH=$HOME/swift-toolchain/usr/bin:$PATH
    echo "export PATH=\$HOME/swift-toolchain/usr/bin:\$PATH" >> .build_env
    echo "export SWIFT_PATH=\$HOME/swift-toolchain/usr/bin" >> .build_env

    swift --version
popd
