#!/bin/bash
set -ex

source $HOME/.build_env

function finish {
    exit_code=$?
    set +e
    unlink $DST_ROOT/swift-nightly-install/usr/lib/swift
    exit $exit_code
}
trap finish EXIT

declare -A swift_archs
swift_archs=(["arm64"]="aarch64" ["arm"]="armv7" ["x86_64"]="x86_64" ["x86"]="i686")

for arch in "${!swift_archs[@]}"
do
    swift_arch=${swift_archs[$arch]}

    ln -sfn $DST_ROOT/swift-nightly-install/usr/lib/swift-$swift_arch $DST_ROOT/swift-nightly-install/usr/lib/swift

    dispatch_build_dir=/tmp/swift-corelibs-libdispatch-$arch
    foundation_build_dir=/tmp/foundation-$arch
    xctest_build_dir=/tmp/xctest-$arch

    for build_dir in $dispatch_build_dir $foundation_build_dir $xctest_build_dir
    do 
        manifest=$build_dir/install_manifest.txt            
        if [ -f $manifest ]
        then
            cat $manifest | xargs rm -f | true
            cat $manifest | xargs -L1 dirname | xargs rmdir -p --ignore-fail-on-non-empty | true
        fi
    done
done