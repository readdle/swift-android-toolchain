#!/bin/bash
set -ex

BASE_DIR=$PWD

# Provisioning
pushd $HOME
	$BASE_DIR/vagrant/provision/010_install_dependencies.sh
	$BASE_DIR/vagrant/provision/020_install_ndk.sh
	$BASE_DIR/vagrant/provision/030_define_build_folders.sh
popd

# Building
pushd $BASE_DIR
	./build/Linux/010-build-icu.sh
    ./build/Linux/020-clone-swift.sh
    ./build/Linux/030-build-swift.sh
    ./build/Linux/040-build-foundation-depends.sh
    ./build/Linux/050-build-corelibs.sh
    ./build/Linux/060-collect.sh
popd

