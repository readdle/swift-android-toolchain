#!/bin/bash
set -ex

source $HOME/.build_env

rm -rf $ICU_LIBS
rm -rf $SWIFT_SRC
rm -rf $DST_ROOT

mkdir $ICU_LIBS
mkdir $SWIFT_SRC
mkdir $DST_ROOT