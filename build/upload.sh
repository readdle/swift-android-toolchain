#!/bin/bash

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

BINTRAY_USER=${1:?Specify bintray user as first arg}
BINTRAY_API_KEY=${2:?Specify bintray apikey as second arg}

pushd $BASE_DIR
    version=`cat build/config/version`
    name="swift-android-${version}"
    filename="${name}.zip"

    curl -T out/$filename \
        -u$BINTRAY_USER:$BINTRAY_API_KEY \
        https://api.bintray.com/content/readdle/swift-android-toolchain/swift-android-toolchain/$version/$filename > /dev/null
popd