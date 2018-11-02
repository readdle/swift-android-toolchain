#!/bin/bash
set -e

SELF_DIR=$(dirname $0)

pushd $SELF_DIR
    if [ "$1" == "--clean" ]
    then
        ./clean.sh
    fi

    if [ "$1" == "--force-clean" ]
    then
        ./clean.sh -f
    fi

    ./build_linux.sh
    ./build_macos.sh
popd