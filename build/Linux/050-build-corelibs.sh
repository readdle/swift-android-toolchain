#!/bin/bash
set -ex

self_dir=$(realpath $(dirname $0))

$self_dir/052-build-corelibs.sh arm64 aarch64 aarch64-linux-android arm64-v8a
$self_dir/052-build-corelibs.sh arm armv7 arm-linux-androideabi armeabi-v7a
$self_dir/052-build-corelibs.sh x86 i686 i686-linux-android x86
$self_dir/052-build-corelibs.sh x86_64 x86_64 x86_64-linux-android x86_64
