#!/bin/bash

SELF_DIR=$(dirname $0)

pushd $SELF_DIR
    if [ "$1" == "--clean" ]
    then
        ./clean.sh
    fi

    ./build_linux.sh
    ./build_macos.sh
popd