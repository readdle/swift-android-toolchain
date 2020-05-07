#!/bin/bash
set -ex

source $HOME/.build_env

DOWNLOAD_URL_OPENSSL=https://www.openssl.org/source/openssl-1.0.2u.tar.gz
GIT_URL_CURL=https://github.com/curl/curl.git
GIT_URL_LIBXML2=https://gitlab.gnome.org/GNOME/libxml2.git

CURL_VERSION=curl-7_59_0
LIBXML2_VERSION=v2.9.7

archs=(arm arm64 x86 x86_64)

rm -rf $STANDALONE_TOOLCHAIN
mkdir -p $STANDALONE_TOOLCHAIN

for arch in ${archs[*]}
do
    $ANDROID_NDK17/build/tools/make_standalone_toolchain.py --api 21 --arch $arch --stl libc++ --install-dir $STANDALONE_TOOLCHAIN/$arch --force -v
done

pushd $STANDALONE_TOOLCHAIN
    mkdir downloads src

    mkdir src/openssl
    wget $DOWNLOAD_URL_OPENSSL -O downloads/openssl.tar.gz # 1.0.2h was the current version at the moment where this script has been written
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
    export SYSROOT=$STANDALONE_TOOLCHAIN/$arch/sysroot
    export PATH=$STANDALONE_TOOLCHAIN/$arch/bin:$ORIGINAL_PATH

    pushd $SYSROOT
        case ${arch} in
            "arm")
                target_host="arm-linux-androideabi"
                openssl_configure_platform="android-armv7"
                arch_flags="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
                arch_link=" -march=armv7-a -Wl,--fix-cortex-a8"
            ;;
            "arm64")
                target_host="aarch64-linux-android"
                openssl_configure_platform="android64-aarch64"
                arch_flags=
                arch_link=
            ;;
            "x86")
                target_host="i686-linux-android"
                openssl_configure_platform="android-x86"
                arch_flags=
                arch_link=
            ;;
            "x86_64")
                target_host="x86_64-linux-android"
                openssl_configure_platform="linux-generic64"
                arch_flags=
                arch_link=
            ;;
        esac

        # Set cross-compilation env variables (taken from https://gist.github.com/VictorLaskin/1c45245d4cdeab033956)

        export CC=$target_host-clang
        export CXX=$target_host-clang++
        export AR=$target_host-ar
        export AS=$target_host-as
        export LD=$target_host-ld
        export RANLIB=$target_host-ranlib
        export NM=$target_host-nm
        export STRIP=$target_host-strip
        export CHOST=$target_host
        export CPPFLAGS=" ${arch_flags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing "
        export CXXFLAGS=" ${arch_flags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -frtti -fexceptions -std=c++11 -Wno-error=unused-command-line-argument "
        export CFLAGS=" ${arch_flags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing "
        export LDFLAGS=" ${arch_link} "

        # Create destination directories

        cp -r $STANDALONE_TOOLCHAIN/src src

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
                --with-zlib-include=$SYSROOT/usr \
                --with-zlib-lib=$SYSROOT/usr \
                --prefix=$SYSROOT/usr \
                --sysroot=$SYSROOT

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
                --with-zlib=$SYSROOT/usr \
                --with-ssl=$SYSROOT/usr \
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
                --prefix=$SYSROOT/usr

            make && make install
        popd

        # Compile libxml2

        pushd src/libxml2
            autoreconf -i
            ./configure \
                --host=$CHOST \
                --with-sysroot=$SYSROOT \
                --with-zlib=$SYSROOT/usr \
                --prefix=$SYSROOT/usr \
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
