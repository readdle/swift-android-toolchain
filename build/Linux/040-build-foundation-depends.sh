#!/bin/bash
set -ex

source $HOME/.build_env

DOWNLOAD_URL_OPENSSL=https://www.openssl.org/source/openssl-1.0.2u.tar.gz
GIT_URL_CURL=https://github.com/curl/curl.git
GIT_URL_LIBXML2=https://gitlab.gnome.org/GNOME/libxml2.git

CURL_VERSION=curl-7_76_0
LIBXML2_VERSION=v2.9.10

archs=(arm arm64 x86 x86_64)

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

ORIGINAL_PATH=$PATH

for arch in ${archs[*]}
do
    install_dir=$FOUNDATION_DEPENDENCIES/$arch
    mkdir -p $install_dir

    pushd $install_dir
        api=21
        toolchain=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64

        case ${arch} in
            "arm")
                target_host="armv7a-linux-androideabi"
                tool_prefix="arm-linux-androideabi"
                openssl_configure_platform="android-armv7"
                arch_flags="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
                arch_link=" -march=armv7-a -Wl,--fix-cortex-a8"
            ;;
            "arm64")
                target_host="aarch64-linux-android"
                tool_prefix="$target_host"
                openssl_configure_platform="android64-aarch64"
                arch_flags=
                arch_link=
            ;;
            "x86")
                target_host="i686-linux-android"
                tool_prefix="$target_host"
                openssl_configure_platform="android-x86"
                arch_flags=
                arch_link=
            ;;
            "x86_64")
                target_host="x86_64-linux-android"
                tool_prefix="$target_host"
                openssl_configure_platform="linux-generic64"
                arch_flags=
                arch_link=
            ;;
        esac

        export PATH=$toolchain/$tool_prefix/bin:$ORIGINAL_PATH

        export CC=$toolchain/bin/$target_host$api-clang
        export CXX=$toolchain/bin/$target_host$api-clang++
        export AR=$toolchain/bin/llvm-ar
        export AS=$CC
        export LD=$toolchain/bin/$tool_prefix-ld
        export RANLIB=$toolchain/bin/llvm-ranlib
        export NM=$toolchain/bin/llvm-nm
        export STRIP=$toolchain/bin/llvm-strip

        export CHOST=$target_host
        export CPPFLAGS=" ${arch_flags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing "
        export CXXFLAGS=" ${arch_flags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -frtti -fexceptions -std=c++11 -Wno-error=unused-command-line-argument "
        export CFLAGS=" ${arch_flags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing "
        export LDFLAGS=" ${arch_link} "


        # Create destination directories

        cp -r $FOUNDATION_DEPENDENCIES/src src

        # Compile openssl

        pushd src/openssl
            # -mandroid option seems to be only for gcc compilers. It was causing troubles with clang
            sed "s/-mandroid //g" Configure > Configure.new && chmod +x Configure.new

            ./Configure.new \
                $openssl_configure_platform \
                no-hw \
                no-asm \
                no-engine \
                no-shared \
                zlib \
                --static \
                --prefix=$install_dir

            pushd crypto
                make buildinf.h
            popd

            make depend build_crypto build_ssl -j 4

            # This subproject is causing issues with install_sw target. We don't need the binaries.
            rm -r apps

            # Create fake empty files to complete installation succesfully
            touch libcrypto.pc libssl.pc openssl.pc

            make install_sw
        popd

        # Compile curl

        pushd src/curl
            autoreconf -i
            ./configure \
                --host=$CHOST \
                --enable-shared \
                --disable-static \
                --disable-dependency-tracking \
                --with-zlib \
                --with-ssl=$install_dir \
                --without-ca-bundle \
                --without-ca-path \
                \
                --enable-ipv6  --enable-http    --enable-ftp \
                --enable-proxy \
                --disable-file --disable-ldap   --disable-ldaps \
                --disable-rtsp --disable-dict   --disable-telnet \
                --disable-tftp --disable-pop3   --disable-imap \
                --disable-smtp --disable-gopher --disable-sspi \
                --disable-manual \
                \
                --target=$CHOST \
                --build=x86_64-unknown-linux-gnu \
                --prefix=$install_dir

            make && make install
        popd

        # Compile libxml2

        pushd src/libxml2
            autoreconf -i
            ./configure \
                --host=$CHOST \
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
