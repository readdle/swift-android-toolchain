#!/bin/bash
set -ex

# Install CoreUtils, Cmake, Ninja
brew install coreutils cmake ninja pkg-config

# Prepare Python
python --version
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
python get-pip.py
pip install six

# Install NDK
pushd $HOME
	wget https://dl.google.com/android/repository/android-ndk-r21e-darwin-x86_64.zip
	unzip android-ndk-r21e-darwin-x86_64.zip
	rm android-ndk-r21e-darwin-x86_64.zip
	echo "export ANDROID_NDK_HOME=$PWD/android-ndk-r21e" >> $HOME/.build_env
popd

# Define build folders
swift_source=$HOME/swift-source
mkdir -p $swift_source
echo "export SWIFT_SRC=$swift_source" >> $HOME/.build_env
