#!/bin/bash

export SYSROOT=$STANDALONE_TOOLCHAIN/sysroot
export PATH=$STANDALONE_TOOLCHAIN/bin:$PATH

# Move dispatch public and private headers to the directory foundation is expecting to get it
mkdir -p $SYSROOT/usr/include/dispatch
cp $SWIFT_SOURCE/swift-corelibs-libdispatch/dispatch/*.h $SYSROOT/usr/include/dispatch
cp $SWIFT_SOURCE/swift-corelibs-libdispatch/private/*.h $SYSROOT/usr/include/dispatch

# Build foundation
pushd $SWIFT_SOURCE/swift-corelibs-foundation
    # Libfoundation script is not completely prepared to handle cross compilation yet.
    ln -s $SWIFT_BUILD/swift-linux-x86_64/lib/swift $SYSROOT/usr/lib/

    # Search path for curl seems to be wrong in foundation
    ln -s $SYSROOT/usr/include/curl $SYSROOT/usr/include/curl/curl

    env \
        SWIFTC="$SWIFT_BUILD/swift-linux-x86_64/bin/swiftc" \
        CLANG="$SWIFT_BUILD/llvm-linux-x86_64/bin/clang" \
        SWIFT="$SWIFT_BUILD/swift-linux-x86_64/bin/swift" \
        SDKROOT="$SWIFT_BUILD/swift-linux-x86_64" \
        BUILD_DIR="$SWIFT_BUILD/foundation-linux-x86_64" \
        DSTROOT="/" \
        PREFIX="/usr/" \
        CFLAGS="-DDEPLOYMENT_TARGET_ANDROID -DDEPLOYMENT_ENABLE_LIBDISPATCH --sysroot=$ANDROID_NDK_HOME/platforms/android-21/arch-arm -I$LIBICONV_ANDROID/armeabi-v7a/include -I${SDKROOT}/lib/swift -I$ANDROID_NDK_HOME/sources/android/support/include -I$SYSROOT/usr/include -I$SWIFT_SOURCE/swift-corelibs-foundation/closure" \
        SWIFTCFLAGS="-DDEPLOYMENT_TARGET_ANDROID -DDEPLOYMENT_ENABLE_LIBDISPATCH -I$ANDROID_NDK_HOME/platforms/android-21/arch-arm/usr/include -L /usr/local/lib/swift/android -I /usr/local/lib/swift/android/armv7" \
        LDFLAGS="-fuse-ld=gold --sysroot=$ANDROID_NDK_HOME/platforms/android-21/arch-arm -L$ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x -L$LIBICONV_ANDROID/armeabi-v7a -L/usr/local/lib/swift/android -L$SYSROOT/usr/lib -ldispatch " \
        SDKROOT=$SYSROOT/usr \
        ./configure \
            Release \
            --target=armv7-none-linux-androideabi \
            --sysroot=$SYSROOT \
            -DXCTEST_BUILD_DIR=$SWIFT_BUILD/xctest-linux-x86_64 \
            -DLIBDISPATCH_SOURCE_DIR=$SWIFT_SOURCE/swift-corelibs-libdispatch \
            -DLIBDISPATCH_BUILD_DIR=$SWIFT_SOURCE/swift-corelibs-libdispatch &&

    # Prepend SYSROOT env variable to ninja.build script
    # SYSROOT is not being passed from build.py / script.py to the ninja file yet
    echo "SYSROOT=$SYSROOT" > build.ninja.new
    cat build.ninja >> build.ninja.new
    sed 's%\-rpath \\\$\$ORIGIN %%g' build.ninja.new > build.ninja
    rm build.ninja.new

    /usr/bin/ninja || {
        echo "$0 failed with code $?"
        exit 1
    }

    # Undo those nasty changes
    unlink $SYSROOT/usr/include/curl/curl
    unlink $SYSROOT/usr/lib/swift
popd