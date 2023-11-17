#!/bin/bash
set -ex

source $HOME/.build_env

OPENSSL_VERSION=1.1.1w

DOWNLOAD_URL_OPENSSL=https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz

archs=(arm arm64 x86 x86_64)

rm -rf $OPENSSL_LIBS
mkdir -p $OPENSSL_LIBS

pushd $OPENSSL_LIBS
    mkdir downloads src

    mkdir src/openssl
    wget $DOWNLOAD_URL_OPENSSL -O downloads/openssl.tar.gz
    tar -xvf downloads/openssl.tar.gz -C src/openssl --strip-components=1

popd
 
API=24
HOST=linux-x86_64
TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/$HOST
PATH=$TOOLCHAIN/bin:$PATH

export CFLAGS="-O3 -g -DNDEBUG -fpic -ffunction-sections -fdata-sections -fstack-protector-strong -funwind-tables -no-canonical-prefixes"

for arch in ${archs[*]}
do
    install_dir=$OPENSSL_LIBS/$arch
    mkdir -p $install_dir

    pushd $install_dir

        # Create destination directories
        cp -r $OPENSSL_LIBS/src src

        # Compile openssl https://github.com/openssl/openssl/blob/master/NOTES-ANDROID.md
        pushd src/openssl

            ./Configure android-$arch -D__ANDROID_API__=$API \
                no-shared \
                no-engine \
                zlib \
                --prefix=$install_dir

            make && make install_sw

        popd

        # Cleanup
        rm -rf src
    popd
done
