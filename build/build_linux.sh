#!/bin/bash
set -ex

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

pushd $BASE_DIR/vagrant
    vagrant up

    vagrant ssh -c /vagrant/scripts/010-build-icu.sh
    vagrant ssh -c /vagrant/scripts/020-clone-swift.sh
    vagrant ssh -c /vagrant/scripts/030-build-swift.sh
    vagrant ssh -c /vagrant/scripts/040-build-foundation-depends.sh
    vagrant ssh -c /vagrant/scripts/050-build-corelibs.sh
    vagrant ssh -c /vagrant/scripts/060-collect.sh

    vagrant halt
popd