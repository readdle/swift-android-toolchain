#!/bin/bash
set -ex

self_dir=$(realpath $(dirname $0))

$self_dir/build-swift-arm64.sh
$self_dir/build-swift-arm.sh
$self_dir/build-swift-x86_64.sh