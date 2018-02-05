#!/bin/bash

# hack for configure
# it is impossible to pass -lswiftCore on configure stage because compiler checking fails
# it trying to check with host linker and fails because of incoreect arch
placeholder=-L/tmp/placeholder

pushd $SWIFT_SOURCE/swift-corelibs-libdispatch
    sh autogen.sh
    env \
        CC="$SWIFT_BUILD/llvm-linux-x86_64/bin/clang" \
        CXX="$SWIFT_BUILD/llvm-linux-x86_64/bin/clang++" \
        SWIFTC="$SWIFT_BUILD/swift-linux-x86_64/bin/swiftc" \
        CFLAGS="-DTRASHIT=''" \
        LIBS="$placeholder -latomic" \
        LDFLAGS="-L$SWIFT_INSTALL/usr/lib/swift/android -L$ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/arm-linux-androideabi/lib/armv7-a" \
        ./configure \
            --with-swift-toolchain="$SWIFT_BUILD/swift-linux-x86_64" \
            --with-build-variant=release \
            --enable-android \
            --host=arm-linux-androideabi \
            --with-android-ndk=$ANDROID_NDK_HOME \
            --with-android-api-level=21 \
            --disable-build-tests \
            --prefix=$SWIFT_INSTALL/usr

    sed -ie "s@$placeholder@-lswiftCore@" src/Makefile

    make && make install || {
        echo "$0 failed with code $?"
        exit 1
    }

    rsync -av $SWIFT_SOURCE/swift-corelibs-libdispatch/src/swift/Dispatch.swift{doc,module} $SWIFT_INSTALL/usr/lib/swift/android/armv7/
popd
