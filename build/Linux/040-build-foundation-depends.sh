#!/bin/bash
set -ex

source $HOME/.build_env

OPENSSL_VERSION=1.1.1m
CURL_VERSION=curl-7_81_0
LIBXML2_VERSION=v2.9.12

DOWNLOAD_URL_OPENSSL=https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
GIT_URL_CURL=https://github.com/curl/curl.git
GIT_URL_LIBXML2=https://gitlab.gnome.org/GNOME/libxml2.git

archs=(arm arm64 x86 x86_64)

rm -rf $FOUNDATION_DEPENDENCIES
mkdir -p $FOUNDATION_DEPENDENCIES

pushd $FOUNDATION_DEPENDENCIES
    mkdir downloads src

    mkdir src/openssl
    wget $DOWNLOAD_URL_OPENSSL -O downloads/openssl.tar.gz
    tar -xvf downloads/openssl.tar.gz -C src/openssl --strip-components=1

    git clone $GIT_URL_CURL src/curl
    pushd src/curl
        git checkout $CURL_VERSION
    popd

    git clone $GIT_URL_LIBXML2 src/libxml2
    pushd src/libxml2
        git checkout $LIBXML2_VERSION
    popd
popd
 
API=21
HOST=linux-x86_64
TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/$HOST

for arch in ${archs[*]}
do
    install_dir=$FOUNDATION_DEPENDENCIES/$arch
    mkdir -p $install_dir

    pushd $install_dir
        case ${arch} in
            "arm")
                TARGET_HOST="arm-linux-androideabi"
                COMPILER_TARGET_HOST="armv7a-linux-androideabi"
                arch_flags="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
                arch_link="-march=armv7-a -Wl,--fix-cortex-a8"
            ;;
            "arm64")
                TARGET_HOST="aarch64-linux-android"
                COMPILER_TARGET_HOST="$TARGET_HOST"
                arch_flags=""
                arch_link=""
            ;;
            "x86")
                TARGET_HOST="i686-linux-android"
                COMPILER_TARGET_HOST="$TARGET_HOST"
                arch_flags=""
                arch_link=""
            ;;
            "x86_64")
                TARGET_HOST="x86_64-linux-android"
                COMPILER_TARGET_HOST="$TARGET_HOST"
                arch_flags=""
                arch_link=""
            ;;
        esac

        export CPPFLAGS=" ${arch_flags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing "
        export CXXFLAGS=" ${arch_flags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -frtti -fexceptions -std=c++11 -Wno-error=unused-command-line-argument "
        export CFLAGS=" ${arch_flags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing "
        export LDFLAGS=" ${arch_link} "

        # Create destination directories
        cp -r $FOUNDATION_DEPENDENCIES/src src

        # Compile openssl https://github.com/openssl/openssl/blob/master/NOTES-ANDROID.md
        pushd src/openssl
            # Save current PATH
            ORIGINAL_PATH=$PATH
            PATH=$TOOLCHAIN/bin:$ANDROID_NDK/toolchains/$TARGET_HOST-4.9/prebuilt/linux-x86_64/bin:$PATH

            ./Configure android-$arch -D__ANDROID_API__=$API \
                no-shared \
                no-engine \
                zlib \
                --prefix=$install_dir

            make && make install_sw

            # Restore PATH
            PATH=$ORIGINAL_PATH
        popd

        export AR=$TOOLCHAIN/bin/$TARGET_HOST-ar
        export AS=$TOOLCHAIN/bin/$TARGET_HOST-as
        export CC=$TOOLCHAIN/bin/$COMPILER_TARGET_HOST$API-clang
        export CXX=$TOOLCHAIN/bin/$COMPILER_TARGET_HOST$API-clang++
        export LD=$TOOLCHAIN/bin/$TARGET_HOST-ld
        export RANLIB=$TOOLCHAIN/bin/$TARGET_HOST-ranlib
        export STRIP=$TOOLCHAIN/bin/$TARGET_HOST-strip

        # Compile curl
        pushd src/curl            
            autoreconf -i
            ./configure \
                --host $TARGET_HOST \
                --with-ssl="$install_dir" \
                --prefix=$install_dir \
                --enable-shared \
                --disable-static \
                --disable-dependency-tracking \
                --with-zlib \
                --without-ca-bundle \
                --without-ca-path \
                --enable-ipv6  --enable-http    --enable-ftp \
                --enable-proxy \
                --disable-file --disable-ldap   --disable-ldaps \
                --disable-rtsp --disable-dict   --disable-telnet \
                --disable-tftp --disable-pop3   --disable-imap \
                --disable-smtp --disable-gopher --disable-sspi \
                --disable-manual

            make && make install
        popd

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

            make libxml2.la && make install-libLTLIBRARIES

            pushd include
                make install
            popd
        popd
    popd
done
