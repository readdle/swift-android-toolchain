#!/bin/bash
set -ex

self_dir=$(realpath $(dirname $0))

$self_dir/031-build-swift-arm64.sh
$self_dir/032-build-swift-arm.sh
$self_dir/033-build-swift-x86_64.sh