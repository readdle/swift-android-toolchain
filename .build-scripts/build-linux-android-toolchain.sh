#!/bin/bash
set -ex

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

pushd $BASE_DIR
	# Provisioning
	./vagrant/provision/010_install_dependencies.sh
	./vagrant/provision/020_install_ndk.sh
	./vagrant/provision/030_define_build_folders.sh

	# Building
	./build/Linux/010-build-icu.sh
    ./build/Linux/020-clone-swift.sh
    ./build/Linux/030-build-swift.sh
    ./build/Linux/040-build-foundation-depends.sh
    ./build/Linux/050-build-corelibs.sh
    ./build/Linux/060-collect.sh
popd

