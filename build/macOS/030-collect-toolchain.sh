#!/bin/bash
set -ex

toolchain_version=`cat build/config/version`
name=swift-android-$toolchain_version

out=out/$name
out_toolchain=$out/toolchain
out_bin=$out_toolchain/usr/bin

mkdir -p $out
mkdir -p $out_toolchain
mkdir -p $out_bin

out=`realpath $out`
out_toolchain=`realpath $out_toolchain`
out_bin=`realpath $out_bin`
linux_out=`realpath vagrant/out`

pushd $linux_out
    mkdir -p usr/bin

    rsync -av swift-android-5.4/swift-nightly-install/ $out_toolchain \
        --include '/usr/lib/' \
        \
        --include '/usr/lib/clang/' \
        --exclude '/usr/lib/clang/lib' \
        --include '/usr/lib/clang/**' \
        \
        --include '/usr/lib/swift-*/' \
        --exclude '/usr/lib/swift-*/pm' \
        --exclude '/usr/lib/swift-*/linux' \
        --exclude '/usr/lib/swift-*/macosx' \
        --exclude '/usr/lib/swift-*/migrator' \
        --include '/usr/lib/swift-*/**' \
        \
        --exclude '/usr/**'

    cp -f /usr/local/bin/pkg-config $out_bin
    cp -f /usr/local/bin/ninja $out_bin

    rsync -av swift-source/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-x86_64/bin/ $out_bin \
        --include swift \
        --include swift-autolink-extract \
        --include swift-stdlib-tool \
        --include swiftc \
        --exclude '*'

    ## Bundle SwiftPM
    cp swift-source/swiftpm/.build/release/swift-build $out_bin

    ## Bundle NDK headers and patch glibc
    mkdir -p $out_toolchain/ndk-android-21/usr
    rsync -av $ANDROID_NDK_HOME/sysroot/usr/include $out_toolchain/ndk-android-21/usr

    for arch in $out_toolchain/usr/lib/swift-*/android
    do
        glibc_modulemap="$arch/glibc.modulemap"
        if [[ ! -f "$glibc_modulemap.orig" ]]
        then
            cp "$glibc_modulemap" "$glibc_modulemap.orig"
        fi

        sed -e 's@/home/vagrant/android-ndk-r17c/sysroot@../../../../../ndk-android-21@' < "$glibc_modulemap.orig" > "$glibc_modulemap"
    done
popd

rsync -av shims/`uname`/ $out_toolchain
rsync -av src/tools/ $out

echo $toolchain_version > $out/VERSION

pushd $(dirname $out)
    zip -y -r $name.zip $name
popd

