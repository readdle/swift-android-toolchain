#!/bin/bash
set -ex

source $HOME/.build_env

declare -A swift_archs
declare -A abis

swift_archs=(["arm64"]="aarch64" ["arm"]="armv7" ["x86_64"]="x86_64" ["x86"]="i686")
abis=(["arm64"]="arm64-v8a" ["arm"]="armeabi-v7a" ["x86_64"]="x86_64" ["x86"]="x86")

for arch in "${!swift_archs[@]}"
do
    swift_arch=${swift_archs[$arch]}
    abi=${abis[$arch]}

    swift_include=$DST_ROOT/swift-nightly-install/usr/lib/swift-$swift_arch
    dst_libs=$DST_ROOT/swift-nightly-install/usr/lib/swift-$swift_arch/android
    sysroot=$STANDALONE_TOOLCHAIN/$arch/sysroot
    foundation_dependencies=$FOUNDATION_DEPENDENCIES/$arch
    icu_libs=$ICU_LIBS/$abi

    rsync -av $ANDROID_NDK/sources/cxx-stl/llvm-libc++/libs/$abi/libc++_shared.so $dst_libs

    rsync -av $icu_libs/libicu{uc,i18n,data}swift.so $dst_libs
    rsync -av $foundation_dependencies/lib/libcrypto.a $dst_libs
    rsync -av $foundation_dependencies/lib/libssl.a $dst_libs
    rsync -av $foundation_dependencies/lib/libcurl.* $dst_libs
    rsync -av $foundation_dependencies/lib/libxml2.* $dst_libs

    cp -r $icu_libs/include/unicode $swift_include
    cp -r $foundation_dependencies/include/openssl $swift_include
    cp -r $foundation_dependencies/include/libxml2/libxml $swift_include
    cp -r $foundation_dependencies/include/curl $swift_include
done



# copy to host
mkdir -p /vagrant/out

rsync -av $DST_ROOT /vagrant/out/
rsync -av $SWIFT_SRC /vagrant/out/ --exclude build