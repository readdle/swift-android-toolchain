#!/bin/bash
set -e

function print_help {
    echo    "Usage: $0 [-f] [-h]" >&2
    echo
    echo    "optional arguments:"
    echo
    echo -e "\t-f\tForce clean linux by destroing VM"
    echo -e "\t-h\tShow this help message and exit"
}

force=0

while getopts ":hf" opt; do
    case $opt in
        f)
            force=1
            ;;
        h)
            print_help
            exit 0
            ;;
        \?)
            echo    "Invalid option: -$OPTARG"
            echo
            print_help
            exit 1
            ;;
    esac
done

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

pushd $BASE_DIR/vagrant
    if (( force == 1 )); then
        vagrant destroy -f
    else
        vagrant up
        vagrant ssh -c /vagrant/scripts/000-clean.sh
    fi
popd

pushd $BASE_DIR
    build/macOS/000-clean.sh
popd
