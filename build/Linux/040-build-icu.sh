#!/bin/bash
set -ex

ROOT_DIR=$(realpath $(dirname $0))/../../
ICU_VERSION=release-73-2

source $HOME/.build_env
export NDK=$ANDROID_NDK
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64

# Clone icu
rm -rf $ICU_LIBS
mkdir -p $ICU_LIBS
git clone https://github.com/unicode-org/icu.git $ICU_LIBS
export ICU_SOURCE=$ICU_LIBS

pushd $ICU_LIBS
    # Checkout version
    git checkout $ICU_VERSION

    # Apply patches for icu
    git apply $ROOT_DIR/patches/icu/*.patch

    # Build ICU for host
    mkdir build-host
    pushd build-host
        # Build ICU for host
        $ICU_SOURCE/icu4c/source/configure
        make -j8
    popd
    export HOST_BUILD=$PWD/build-host

    export CFLAGS="-O3 -DNDEBUG -fpic -ffunction-sections -fdata-sections -fstack-protector-strong -funwind-tables -no-canonical-prefixes -Wformat -Werror=format-security -fvisibility=hidden -fomit-frame-pointer -g -flto"
    export CXXFLAGS="-fexceptions -frtti -O3 -DNDEBUG -fpic -ffunction-sections -fdata-sections -fstack-protector-strong -funwind-tables -no-canonical-prefixes -Wformat -Werror=format-security -fvisibility=hidden -fomit-frame-pointer -g -flto"
    export LDFLAGS="-Wl,--gc-sections"

    targets=(armv7a-linux-androideabi aarch64-linux-android i686-linux-android x86_64-linux-android)
    for target in ${targets[*]}
    do
        # Build ICU for Android $target
        export TARGET=$target
        mkdir build-$target -p
        pushd build-$target
            # Setup toolchain for current target    
            export API=24
            export AR=$TOOLCHAIN/bin/llvm-ar
            export CC=$TOOLCHAIN/bin/$TARGET$API-clang
            export AS=$CC
            export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
            export LD=$TOOLCHAIN/bin/ld
            export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
            export STRIP=$TOOLCHAIN/bin/llvm-strip

            # Build ICU for current target
            $ICU_SOURCE/icu4c/source/configure \
                --host $TARGET \
                --with-cross-build=$HOST_BUILD \
                --enable-static=yes \
                --enable-shared=yes
            make -j8
            
            # Copy headers
            mkdir -p lib/include/unicode
            cp $ICU_SOURCE/icu4c/source/*/unicode/*.h lib/include/unicode
        popd
    done
popd