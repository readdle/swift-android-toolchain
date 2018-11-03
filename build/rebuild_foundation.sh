#!/bin/bash
set -e

SELF_DIR=$(dirname $0)

pushd $SELF_DIR/../vagrant
    vagrant ssh -c /vagrant/scripts/060_build_corelibs_foundation.sh

    vagrant scp :~/swift-source/build/Ninja-ReleaseAssert+stdlib-Release/foundation-linux-x86_64/Foundation/libFoundation.so \
        $SWIFT_ANDROID_HOME/toolchain/usr/lib/swift/android/
    vagrant scp :~/swift-source/build/Ninja-ReleaseAssert+stdlib-Release/foundation-linux-x86_64/Foundation/Foundation.swiftmodule \
        $SWIFT_ANDROID_HOME/toolchain/usr/lib/swift/android/armv7/
    vagrant scp :~/swift-source/build/Ninja-ReleaseAssert+stdlib-Release/foundation-linux-x86_64/Foundation/Foundation.swiftdoc \
        $SWIFT_ANDROID_HOME/toolchain/usr/lib/swift/android/armv7/

    rpl -R -e libicu libscu $SWIFT_ANDROID_HOME/toolchain/usr/lib/swift/android/libFoundation.so
popd
