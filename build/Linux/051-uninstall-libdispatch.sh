#!/bin/bash
set -ex

archs=(aarch64 armv7 x86_64)

rm -rf $DST_ROOT/swift-nightly-install/usr/lib/swift/dispatch

for arch in ${archs[*]}
do
    rm -rf $DST_ROOT/swift-nightly-install/usr/lib/swift/android/$arch/libdispatch.so
    rm -rf $DST_ROOT/swift-nightly-install/usr/lib/swift/android/$arch/libBlocksRuntime.so
    rm -rf $DST_ROOT/swift-nightly-install/usr/lib/swift/android/$arch/libswiftDispatch.so
    rm -rf $DST_ROOT/swift-nightly-install/usr/lib/swift/android/$arch/Dispatch.swiftdoc
    rm -rf $DST_ROOT/swift-nightly-install/usr/lib/swift/android/$arch/Dispatch.swiftmodule
done