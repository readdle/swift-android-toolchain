#!/bin/bash
set -ex

source $HOME/.build_env

self_dir=$(realpath $(dirname $0))

arch=$1 # arm64 arm x86 x86_64
swift_arch=$2 # aarch64 armv7 i686 x86_64
clang_arch=$3 # aarch64-linux-android arm-linux-androideabi i686-linux-android x86_64-linux-android 
abi=$4 # arm64-v8a armeabi-v7a x86 x86_64
ndk_arch=$5 # aarch64-linux-android armv7a-linux-androideabi i686-linux-android x86_64-linux-android 

dispatch_build_dir=/tmp/swift-corelibs-libdispatch-$arch
foundation_build_dir=/tmp/foundation-$arch
xctest_build_dir=/tmp/xctest-$arch

openssl_libs=$OPENSSL_LIBS/$arch
curl_libs=$CURL_LIBS/$arch
libxml_libs=$LIBXML_LIBS/$arch

rm -rf $dispatch_build_dir
rm -rf $foundation_build_dir
rm -rf $xctest_build_dir

mkdir -p $dispatch_build_dir
mkdir -p $foundation_build_dir
mkdir -p $xctest_build_dir

# Copy andorid stdlib to NDK
cp -r ~/swift-android/lib/swift $ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib

pushd $dispatch_build_dir
    cmake $DISPATCH_SRC \
        -G Ninja \
        -C $self_dir/common-flags.cmake \
        -C $self_dir/common-flags-$arch.cmake \
        \
        -DENABLE_SWIFT=YES 

    cmake --build $dispatch_build_dir --verbose
popd

pushd $foundation_build_dir
    cmake $FOUNDATION_SRC \
        -G Ninja \
        -C $self_dir/common-flags.cmake \
        -C $self_dir/common-flags-$arch.cmake \
        \
        -Ddispatch_DIR=$dispatch_build_dir/cmake/modules \
        -D_SwiftSyntax_SourceDIR=$SWIFT_SRC/swift-syntax \
        -D_SwiftFoundation_SourceDIR=$SWIFT_SRC/swift-foundation \
        -D_SwiftFoundationICU_SourceDIR=$SWIFT_SRC/swift-foundation-icu \
        -D_SwiftCollections_SourceDIR=$SWIFT_SRC/swift-collections \
        \
        -DCURL_LIBRARY=$curl_libs/lib/libcurl.so \
        -DCURL_INCLUDE_DIR=$curl_libs/include \
        \
        -DLIBXML2_LIBRARY=$libxml_libs/lib/libxml2.so \
        -DLIBXML2_INCLUDE_DIR=$libxml_libs/include/libxml2 \
        \
        -DCMAKE_HAVE_LIBC_PTHREAD=YES

    cmake --build $foundation_build_dir --verbose
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

    cmake --build $xctest_build_dir --verbose
popd

dispatch_build_dir=/tmp/swift-corelibs-libdispatch-$arch
foundation_build_dir=/tmp/foundation-$arch
xctest_build_dir=/tmp/xctest-$arch

# We need to install dispatch at the end because it is impossible to build foundation after dispatch installed
cmake --build $dispatch_build_dir --target install
cmake --build $foundation_build_dir --target install
cmake --build $xctest_build_dir --target install

# Copy dependency headers and libraries
swift_include=$HOME/swift-toolchain/usr/lib/swift
dst_libs=$HOME/swift-toolchain/usr/lib/swift/android

rsync -av $ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$clang_arch/libc++_shared.so $dst_libs

rsync -av $openssl_libs/lib/libcrypto.a $dst_libs
rsync -av $openssl_libs/lib/libssl.a $dst_libs
rsync -av $curl_libs/lib/libcurl.* $dst_libs
rsync -av $libxml_libs/lib/libxml2.* $dst_libs

cp -r $openssl_libs/include/openssl $swift_include
cp -r $curl_libs/include/curl $swift_include
cp -r $libxml_libs/include/libxml2/libxml $swift_include

# Copy to unicode headers
pushd $HOME/swift-toolchain/usr/lib/swift
    cp -r _foundation_unicode unicode
    rm -rf unicode/module.modulemap
popd

# Cleanup host libraries
rm -rf $HOME/swift-toolchain/usr/lib/swift/host
rm -rf $HOME/swift-toolchain/usr/lib/swift/linux
