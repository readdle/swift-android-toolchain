#!/bin/bash

GIT_URL_SWIFT=https://github.com/SwiftJava/swift.git

pushd $SWIFT_SOURCE
    git clone $GIT_URL_SWIFT

    swift/utils/update-checkout --clone

    # checkout 
    cd clang       && git checkout e352443ae3832ddb64f071fe2f9d201f25ec7c40 && cd - &&
    cd cmark       && git checkout d875488a6a95d5487b7c675f79a8dafef210a65f && cd - &&
    cd compiler-rt && git checkout e0e24585ee1c8941a13465a34baa5cc0e66a705c && cd - &&
    cd llbuild     && git checkout 1370ca71339b0c2a01d660834f83f22c94845633 && cd - &&
    cd lldb        && git checkout a3a5134d7f083f643d09316d41094802cc117db9 && cd - &&
    cd ninja       && git checkout 256bf897b85e35bc90294090ad39b5214eb141fb && cd - &&

    cd swift && git checkout android-toolchain-1.0 && cd - &&

    rm -rf llvm                       && git clone https://github.com/SwiftJava/swift-llvm.git llvm &&
    cd llvm                           && git checkout android-toolchain-1.0.3 && cd - &&

    rm -rf swift-corelibs-libdispatch && git clone https://github.com/SwiftJava/swift-corelibs-libdispatch.git &&
    cd swift-corelibs-libdispatch     && git checkout android-toolchain-1.0 && cd - &&

    rm -rf swift-corelibs-foundation  && git clone https://github.com/johnno1962b/swift-corelibs-foundation.git &&
    cd swift-corelibs-foundation      && git checkout 2448bc731436649fd6e21c2ddacbd1a207c31037 && cd - &&

    rm -rf swift-corelibs-xctest      && git clone https://github.com/SwiftJava/swift-corelibs-xctest.git &&
    cd swift-corelibs-xctest          && git checkout android-toolchain-1.0 && cd - &&

    cd swift-integration-tests        && git checkout 1d5d149f7aab027c9a7dccd19c0680bf36761a68 && cd - &&
    cd swift-xcode-playground-support && git checkout 05737c49f04b9089392b599ad529ab91c7119a75 && cd - &&

    rm -rf swiftpm                    && git clone https://github.com/zayass/swift-package-manager.git swiftpm && 
    cd swiftpm                        && git checkout swift-4.0-branch && cd -

popd