#!/bin/bash
set -ex

source $HOME/.build_env

LIBXML2_VERSION=v2.14.3
LIBXML2_SOURCE=https://gitlab.gnome.org/GNOME/libxml2/-/archive/$LIBXML2_VERSION/libxml2-$LIBXML2_VERSION.tar.gz

archs=(arm arm64 x86 x86_64)

rm -rf $LIBXML_LIBS
mkdir -p $LIBXML_LIBS

pushd $LIBXML_LIBS
    mkdir -p downloads src/libxml2
    wget $LIBXML2_SOURCE -O downloads/libxml.tar.gz
    tar -xvf downloads/libxml.tar.gz -C src/libxml2 --strip-components=1
popd
 
API=29
HOST=linux-x86_64
TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/$HOST

export CFLAGS="-O3 -g -DNDEBUG -fno-semantic-interposition -fpic -ffunction-sections -fdata-sections -fstack-protector-strong -funwind-tables -no-canonical-prefixes"
export LDFLAGS="$LDFLAGS -Wl,--build-id=sha1 -Wl,-z,max-page-size=16384"

for arch in ${archs[*]}
do
    install_dir=$LIBXML_LIBS/$arch
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
        cp -r $LIBXML_LIBS/src src

        export AR=$TOOLCHAIN/bin/llvm-ar
        export AS=$TOOLCHAIN/bin/llvm-as
        export CC=$TOOLCHAIN/bin/$COMPILER_TARGET_HOST-clang
        export CXX=$TOOLCHAIN/bin/$COMPILER_TARGET_HOST-clang++
        export LD=$TOOLCHAIN/bin/ld
        export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
        export STRIP=$TOOLCHAIN/bin/llvm-strip

        # Compile libxml2
        pushd src/libxml2
            autoreconf -i
            ./configure \
                --host=$TARGET_HOST \
                --with-zlib \
                --prefix=$install_dir \
                --disable-static \
                --enable-shared \
                --without-lzma \
                --without-http \
                --with-html \
                --without-ftp

            make install-libLTLIBRARIES

            pushd include
                make install
            popd
        popd

        # Cleanup
        rm -rf src
    popd
done
