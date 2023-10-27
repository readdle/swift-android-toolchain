#!/bin/bash
set -ex

# Install CoreUtils, Cmake, Ninja, Python3
brew install coreutils cmake ninja pkg-config python

# Prepare Python
python --version
pip3 install six

# Define build folders
swift_source=$HOME/swift-source
mkdir -p $swift_source
echo "export SWIFT_SRC=$swift_source" >> $HOME/.build_env
