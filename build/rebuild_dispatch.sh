#!/bin/bash
set -e

SELF_DIR=$(dirname $0)

pushd $SELF_DIR/../vagrant
    vagrant ssh -c /vagrant/scripts/040_build_corelibs_libdispatch.sh

   vagrant scp :~/swift-source/swift-corelibs-libdispatch/src/.libs/libdispatch.so \
        $SWIFT_ANDROID_HOME/toolchain/usr/lib/swift/android/
   vagrant scp :~/swift-source/swift-corelibs-libdispatch/src/.libs/libdispatch.la \
        $SWIFT_ANDROID_HOME/toolchain/usr/lib/swift/android/
    vagrant scp :/home/vagrant/swift-install/usr/lib/swift/android/armv7/Dispatch.swiftdoc \
        $SWIFT_ANDROID_HOME/toolchain/usr/lib/swift/android/
    vagrant scp :/home/vagrant/swift-install/usr/lib/swift/android/armv7/Dispatch.swiftmodule \
        $SWIFT_ANDROID_HOME/toolchain/usr/lib/swift/android/
popd
