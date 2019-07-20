#!/bin/bash
set -ex

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

pushd $BASE_DIR/vagrant
    vagrant up

    vagrant ssh -c /vagrant/scripts/build-icu.sh
    vagrant ssh -c /vagrant/scripts/clone-swift.sh
    vagrant ssh -c /vagrant/scripts/build-swift.sh
    vagrant ssh -c /vagrant/scripts/build-foundation-depends.sh
    vagrant ssh -c /vagrant/scripts/build-corelibs.sh
    vagrant ssh -c /vagrant/scripts/collect.sh

    vagrant halt
popd