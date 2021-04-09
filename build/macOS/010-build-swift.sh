#!/bin/bash
set -ex

BASE_DIR=`pwd`
SWIFT_SOURCE=$BASE_DIR/vagrant/out/swift-source

export SKIP_XCODE_VERSION_CHECK=1
unset TOOLCHAINS

pushd $SWIFT_SOURCE/swift
    utils/build-script \
        --release \
        --assertions \
        --no-swift-stdlib-assertions \
        --swift-enable-ast-verifier=0 \
        --swift-darwin-supported-archs "$(uname -m)" \
        --skip-ios \
        --skip-tvos \
        --skip-watchos \
        --skip-build-benchmarks \
        --skip-test-osx
popd