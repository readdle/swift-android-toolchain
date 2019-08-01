#!/bin/bash
set -ex

source $HOME/.build_env

export ANDROID_NDK=$ANDROID_NDK17

self_dir=$(realpath $(dirname $0))

declare -A abis
abis=(["arm64"]="arm64-v8a" ["arm"]="armeabi-v7a" ["x86_64"]="x86_64")

$self_dir/051-uninstall-libdispatch.sh

for arch in "${!abis[@]}"
do
    abi=${abis[$arch]}

    dispatch_build_dir=/tmp/swift-corelibs-libdispatch-$arch
    foundation_build_dir=/tmp/foundation-$arch
    xctest_build_dir=/tmp/xctest-$arch

    sysroot=$STANDALONE_TOOLCHAIN/$arch/sysroot
    icu_libs=$ICU_LIBS/$abi

    rm -rf $dispatch_build_dir
    rm -rf $foundation_build_dir
    rm -rf $xctest_build_dir

    mkdir -p $dispatch_build_dir
    mkdir -p $foundation_build_dir
    mkdir -p $xctest_build_dir

    pushd $dispatch_build_dir
        cmake $DISPATCH_SRC \
            -G Ninja \
            -C $self_dir/common-flags-$arch.cmake \
            -DCMAKE_SWIFT_COMPILER=$DST_ROOT/swift-nightly-install/usr/bin/swiftc \
            -DCMAKE_INSTALL_PREFIX=$DST_ROOT/swift-nightly-install/usr \
            \
            -DENABLE_TESTING=NO \
            -DENABLE_SWIFT=YES 

        cmake --build $dispatch_build_dir
    popd

    pushd $foundation_build_dir
        # Search path for curl seems to be wrong in foundation
        ln -s $sysroot/usr/include/curl $sysroot/usr/include/curl/curl

        cmake $FOUNDATION_SRC \
            -G Ninja \
            -C $self_dir/common-flags-$arch.cmake \
            -DCMAKE_SWIFT_COMPILER=$DST_ROOT/swift-nightly-install/usr/bin/swiftc \
            -DCMAKE_INSTALL_PREFIX=$DST_ROOT/swift-nightly-install/usr \
            \
            -DFOUNDATION_PATH_TO_LIBDISPATCH_SOURCE=$DISPATCH_SRC \
            -DFOUNDATION_PATH_TO_LIBDISPATCH_BUILD=$dispatch_build_dir \
            \
            -DICU_UC_LIBRARY=$icu_libs/libicuucswift.so \
            -DICU_I18N_LIBRARY=$icu_libs/libicui18nswift.so \
            -DICU_INCLUDE_DIR=$icu_libs/include \
            \
            -DCURL_LIBRARY=$sysroot/usr/lib/libcurl.so \
            -DCURL_INCLUDE_DIR=$sysroot/usr/include/curl \
            \
            -DLIBXML2_LIBRARY=$sysroot/usr/lib/libxml2.so \
            -DLIBXML2_INCLUDE_DIR=$sysroot/usr/include/libxml2

        cmake --build $foundation_build_dir

        # Undo those nasty changes
        unlink $SYSROOT/usr/include/curl/curl
    popd

    pushd $xctest_build_dir
        cmake $XCTEST_SRC \
            -G Ninja \
            -C $self_dir/common-flags-$arch.cmake \
            -DCMAKE_SWIFT_COMPILER=$DST_ROOT/swift-nightly-install/usr/bin/swiftc \
            -DCMAKE_INSTALL_PREFIX=$DST_ROOT/swift-nightly-install/usr \
            \
            -DENABLE_TESTING=NO \
            -DXCTEST_PATH_TO_LIBDISPATCH_SOURCE=$DISPATCH_SRC \
            -DXCTEST_PATH_TO_LIBDISPATCH_BUILD=$dispatch_build_dir \
            -DXCTEST_PATH_TO_FOUNDATION_BUILD=$foundation_build_dir

        cmake --build $xctest_build_dir
    popd
done

for arch in "${!abis[@]}"
do
    dispatch_build_dir=/tmp/swift-corelibs-libdispatch-$arch
    foundation_build_dir=/tmp/foundation-$arch
    xctest_build_dir=/tmp/xctest-$arch

    # We need to install dispatch at the end because it is impossible to build foundation after dispatch installed
    cmake --build $dispatch_build_dir --target install
    cmake --build $foundation_build_dir --target install
    cmake --build $xctest_build_dir --target install
done
