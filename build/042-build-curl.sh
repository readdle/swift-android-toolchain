#!/bin/bash
set -ex

source $HOME/.build_env

CURL_VERSION=curl-7_88_1

GIT_URL_CURL=https://github.com/curl/curl.git

archs=(arm arm64 x86 x86_64)

rm -rf $CURL_LIBS
mkdir -p $CURL_LIBS

pushd $CURL_LIBS
    mkdir downloads src

    git clone $GIT_URL_CURL src/curl
    pushd src/curl
        git checkout $CURL_VERSION
    popd
popd
 
API=29
HOST=linux-x86_64
TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/$HOST

export CFLAGS="-O3 -g -DNDEBUG -fpic -ffunction-sections -fdata-sections -fstack-protector-strong -funwind-tables -no-canonical-prefixes"
export LDFLAGS="$LDFLAGS -Wl,--build-id=sha1"

for arch in ${archs[*]}
do
    install_dir=$CURL_LIBS/$arch
    mkdir -p $install_dir

    pushd $install_dir
        case ${arch} in
            "arm")
                TARGET_HOST="arm-linux-androideabi"
                COMPILER_TARGET_HOST="armv7a-linux-androideabi$API"
            ;;
            "arm64")
                TARGET_HOST="aarch64-linux-android"
                COMPILER_TARGET_HOST="$TARGET_HOST$API"
            ;;
            "x86")
                TARGET_HOST="i686-linux-android"
                COMPILER_TARGET_HOST="$TARGET_HOST$API"
            ;;
            "x86_64")
                TARGET_HOST="x86_64-linux-android"
                COMPILER_TARGET_HOST="$TARGET_HOST$API"
            ;;
        esac

        # Create destination directories
        cp -r $CURL_LIBS/src src

        export AR=$TOOLCHAIN/bin/llvm-ar
        export AS=$TOOLCHAIN/bin/llvm-as
        export CC=$TOOLCHAIN/bin/$COMPILER_TARGET_HOST-clang
        export CXX=$TOOLCHAIN/bin/$COMPILER_TARGET_HOST-clang++
        export LD=$TOOLCHAIN/bin/ld
        export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
        export STRIP=$TOOLCHAIN/bin/llvm-strip

        # Compile curl
        pushd src/curl            
            autoreconf -i
            ./configure \
                --host $TARGET_HOST \
                --with-ssl=$OPENSSL_LIBS/$arch \
                --prefix=$install_dir \
                --enable-shared \
                --disable-static \
                --disable-dependency-tracking \
                --with-zlib \
                --without-ca-bundle \
                --without-ca-path \
                --enable-ipv6  --enable-http    --enable-ftp \
                --enable-proxy

            make && make install
        popd

        # Cleanup
        rm -rf src
    popd
done
