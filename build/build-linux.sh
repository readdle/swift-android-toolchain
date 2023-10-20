#!/bin/bash
set -ex

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

pushd $BASE_DIR
    build/Linux/000-install-dependencies.sh
    build/Linux/002-install-ndk.sh
    build/Linux/003-define-build-folders.sh
    build/Linux/010-build-icu.sh
    build/Linux/020-clone-swift.sh
    build/Linux/030-build-swift.sh
    build/Linux/040-build-foundation-depends.sh
    build/Linux/050-build-corelibs.sh
    build/Linux/060-collect-toolchain.sh
popd