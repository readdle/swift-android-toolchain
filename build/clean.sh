#!/bin/bash

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

pushd $BASE_DIR/vagrant
    vagrant up
    vagrant ssh -c /vagrant/scripts/000_clean.sh
popd

pushd $BASE_DIR
    build/macOS/000_clean.sh
popd