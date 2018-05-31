#!/bin/bash

SELF_DIR=$(dirname $0)

pushd $SELF_DIR/../vagrant
    vagrant ssh -c /vagrant/scripts/060_build_corelibs_foundation.sh
    vagrant scp :~/swift-source/build/Ninja-ReleaseAssert/foundation-linux-x86_64/Foundation/libFoundation.so $SWIFT_ANDROID_HOME/toolchain/usr/lib/swift/android/
    rpl -R -e libicu libscu $SWIFT_ANDROID_HOME/toolchain/usr/lib/swift/android/libFoundation.so
popd
