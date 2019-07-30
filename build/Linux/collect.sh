#!/bin/bash
set -ex

source $HOME/.build_env

swift_include=$DST_ROOT/swift-nightly-install/usr/lib/swift

declare -A icu_abis
declare -A swift_archs

swift_archs=(["arm64"]="aarch64" ["arm"]="armv7" ["x86_64"]="x86_64")
icu_abis=(["arm64"]="arm64-v8a" ["arm"]="armeabi-v7a" ["x86_64"]="x86_64")

for arch in "${!swift_archs[@]}"
do
    swift_arch=${swift_archs[$arch]}
    abi=${icu_abis[$arch]}

    dst_libs=$DST_ROOT/swift-nightly-install/usr/lib/swift/android/$swift_arch
    sysroot=$STANDALONE_TOOLCHAIN/$arch/sysroot
    icu_libs=$ICU_LIBS/$abi

    cp $icu_libs/*.so $dst_libs

    rsync -av $ANDROID_NDK17/sources/cxx-stl/llvm-libc++/libs/$abi/libc++_shared.so $dst_libs
    rsync -av $icu_libs/libicu{uc,i18n,data}swift.so $dst_libs
    rsync -av $sysroot/usr/lib/libxml2.* $dst_libs
    rsync -av $sysroot/usr/lib/libcurl.* $dst_libs
done

cp -r $ICU_LIBS/armeabi-v7a/include/unicode $swift_include
cp -r $STANDALONE_TOOLCHAIN/arm/sysroot/usr/include/libxml2/libxml $swift_include
cp -r $STANDALONE_TOOLCHAIN/arm/sysroot/usr/include/curl $swift_include

# copy to host
mkdir -p /vagrant/out

rsync -av $DST_ROOT /vagrant/out/
rsync -av $SWIFT_SRC /vagrant/out/ --exclude build
