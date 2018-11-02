#!/bin/bash
set -e

BINTRAY_USER=${BINTRAY_USER:?BINTRAY_USER env variable should be set}
BINTRAY_API_KEY=${BINTRAY_API_KEY:?BINTRAY_API_KEY env variable should be set}

ORG=readdle
REPO=swift-android-toolchain
PACKAGE=swift-android-toolchain

function main {
    local version=`cat build/config/version`

    create_version $version
    upload_file $version
}

function create_version {
    local version=$1

    local data="{
        \"name\": \"$version\"
    }"

    curl \
        -u$BINTRAY_USER:$BINTRAY_API_KEY \
        -X POST -d "$data" \
        -H "Content-Type: application/json" \
        https://api.bintray.com/packages/$ORG/$REPO/$PACKAGE/versions

    echo
}

function upload_file {
    local version=$1

    local name="swift-android-${version}"
    local filename="${name}.zip"

    curl \
        -u$BINTRAY_USER:$BINTRAY_API_KEY \
        -T out/$filename \
        -H "X-Bintray-Package: $PACKAGE" \
        -H "X-Bintray-Version: $version" \
        -H "X-Bintray-Publish: 1" \
        -H "X-Bintray-Override: 1" \
        https://api.bintray.com/content/$ORG/$REPO/$filename > /dev/null

    show_in_download_list $filename
}

function show_in_download_list {
    local filename=$1

    local data='{
        "list_in_downloads": true
    }'

    curl \
        -u$BINTRAY_USER:$BINTRAY_API_KEY \
        -X PUT -d "$data" \
        -H "Content-Type: application/json" \
        https://api.bintray.com/file_metadata/$ORG/$REPO/$filename > /dev/null
}

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

pushd $BASE_DIR
    main
popd
