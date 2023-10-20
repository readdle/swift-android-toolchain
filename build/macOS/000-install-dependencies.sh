#!/bin/bash
set -ex

# Install CoreUtils, Cmake, Ninja
brew install coreutils cmake ninja pkg-config

# Prepare Python
python --version
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
python get-pip.py
pip install six

# Define build folders
swift_source=$HOME/swift-source
mkdir -p $swift_source
echo "export SWIFT_SRC=$swift_source" >> $HOME/.build_env
