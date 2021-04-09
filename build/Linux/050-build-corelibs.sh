#!/bin/bash
set -ex

source $HOME/.build_env

self_dir=$(realpath $(dirname $0))

declare -A swift_archs
declare -A abis

swift_archs=(["arm64"]="aarch64" ["arm"]="armv7" ["x86_64"]="x86_64" ["x86"]="i686")
abis=(["arm64"]="arm64-v8a" ["arm"]="armeabi-v7a" ["x86_64"]="x86_64" ["x86"]="x86")

$self_dir/051-uninstall-corelibs.sh

for arch in "${!abis[@]}"
do
    abi=${abis[$arch]}
    swift_arch=${swift_archs[$arch]}

    dispatch_build_dir=/tmp/swift-corelibs-libdispatch-$arch
    foundation_build_dir=/tmp/foundation-$arch
    xctest_build_dir=/tmp/xctest-$arch

    foundation_dependencies=$FOUNDATION_DEPENDENCIES/$arch
    icu_libs=$ICU_LIBS/$abi

    rm -rf $dispatch_build_dir
    rm -rf $foundation_build_dir
    rm -rf $xctest_build_dir

    mkdir -p $dispatch_build_dir
    mkdir -p $foundation_build_dir
    mkdir -p $xctest_build_dir

    ln -sfn $DST_ROOT/swift-nightly-install/usr/lib/swift-$swift_arch $DST_ROOT/swift-nightly-install/usr/lib/swift

    pushd $dispatch_build_dir
        cmake $DISPATCH_SRC \
            -G Ninja \
            -C $self_dir/common-flags.cmake \
            -C $self_dir/common-flags-$arch.cmake \
            \
            -DENABLE_SWIFT=YES 

        cmake --build $dispatch_build_dir
    popd

    pushd $foundation_build_dir
        cmake $FOUNDATION_SRC \
            -G Ninja \
            -C $self_dir/common-flags.cmake \
            -C $self_dir/common-flags-$arch.cmake \
            \
            -Ddispatch_DIR=$dispatch_build_dir/cmake/modules \
            \
            -DICU_INCLUDE_DIR=$icu_libs/include \
            -DICU_UC_LIBRARY=$icu_libs/libicuucswift.so \
            -DICU_UC_LIBRARY_RELEASE=$icu_libs/libicuucswift.so \
            -DICU_I18N_LIBRARY=$icu_libs/libicui18nswift.so \
            -DICU_I18N_LIBRARY_RELEASE=$icu_libs/libicui18nswift.so \
            \
            -DCURL_LIBRARY=$foundation_dependencies/lib/libcurl.so \
            -DCURL_INCLUDE_DIR=$foundation_dependencies/include/curl \
            \
            -DLIBXML2_LIBRARY=$foundation_dependencies/lib/libxml2.so \
            -DLIBXML2_INCLUDE_DIR=$foundation_dependencies/include/libxml2 \
            \
            -DCMAKE_HAVE_LIBC_PTHREAD=YES

        cmake --build $foundation_build_dir
    popd

    pushd $xctest_build_dir
        cmake $XCTEST_SRC \
            -G Ninja \
            -C $self_dir/common-flags.cmake \
            -C $self_dir/common-flags-$arch.cmake \
            \
            -DENABLE_TESTING=NO \
            -Ddispatch_DIR=$dispatch_build_dir/cmake/modules \
            -DFoundation_DIR=$foundation_build_dir/cmake/modules

        cmake --build $xctest_build_dir
    popd
done

for arch in "${!abis[@]}"
do
    dispatch_build_dir=/tmp/swift-corelibs-libdispatch-$arch
    foundation_build_dir=/tmp/foundation-$arch
    xctest_build_dir=/tmp/xctest-$arch

    ln -sfn $DST_ROOT/swift-nightly-install/usr/lib/swift-$arch $DST_ROOT/swift-nightly-install/usr/lib/swift

    # We need to install dispatch at the end because it is impossible to build foundation after dispatch installed
    cmake --build $dispatch_build_dir --target install
    cmake --build $foundation_build_dir --target install
    cmake --build $xctest_build_dir --target install
done

unlink $DST_ROOT/swift-nightly-install/usr/lib/swift
