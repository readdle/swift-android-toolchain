#!/bin/bash
set -e

unset TOOLCHAINS

BASE_DIR=`pwd`
SWIFT_SOURCE=$BASE_DIR/vagrant/out/swift-source

pushd $SWIFT_SOURCE/swift
    utils/build-script \
        --release \
        --assertions \
        --no-swift-stdlib-assertions \
        --swift-enable-ast-verifier=0 \
        --skip-ios \
        --skip-tvos \
        --skip-watchos \
        --skip-build-benchmarks \
        --skip-test-osx \
        --skip-build-osx
popd
