#!/bin/bash

pushd vagrant/out/swift-source/swiftpm
    swift build --configuration release
popd