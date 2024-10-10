#!/bin/bash
set -ex

source $HOME/.build_env

unset TOOLCHAINS

pushd $SWIFT_SRC/swift
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