#!/bin/bash
set -ex

source $HOME/.build_env

name=swift-android

out_bin=~/bin
mkdir -p $out_bin

cp -f $SWIFT_SRC/swiftpm/.build/release/swift-build $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/llvm-macosx-arm64/lib/libIndexStore.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/lib/swift/host/libSwiftBasicFormat.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/lib/swift/host/libSwiftCompilerPluginMessageHandling.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/lib/swift/host/libSwiftDiagnostics.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/lib/swift/host/libSwiftIDEUtils.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/lib/swift/host/libSwiftOperators.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/lib/swift/host/libSwiftParser.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/lib/swift/host/libSwiftParserDiagnostics.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/lib/swift/host/libSwiftSyntax.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/lib/swift/host/libSwiftSyntaxBuilder.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/lib/swift/host/libSwiftSyntaxMacroExpansion.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/lib/swift/host/libSwiftSyntaxMacros.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/earlyswiftdriver-macosx-arm64/release/lib/libSwiftDriver.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/earlyswiftdriver-macosx-arm64/release/lib/libSwiftDriverExecution.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/earlyswiftdriver-macosx-arm64/release/lib/libSwiftOptions.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/earlyswiftdriver-macosx-arm64/release/dependencies/swift-tools-support-core/lib/libTSCBasic.dylib $out_bin
cp -f $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/earlyswiftdriver-macosx-arm64/release/dependencies/swift-tools-support-core/lib/libTSCUtility.dylib $out_bin

rsync -av $SWIFT_SRC/build/Ninja-ReleaseAssert+stdlib-Release/swift-macosx-arm64/bin/ $out_bin \
        --include swift \
        --include swift-autolink-extract \
        --include swift-stdlib-tool \
        --include swiftc \
        --include swift-frontend \
        --include swift-driver \
        --exclude '*'

pushd $HOME
    tar -cvf $name-bin.tar bin
popd
