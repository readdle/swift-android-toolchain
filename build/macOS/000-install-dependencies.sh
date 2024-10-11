#!/bin/bash
set -ex

# Install CoreUtils, Cmake, Ninja, Python3
brew install coreutils cmake ninja pkg-config pyenv

pyenv install 3.11.5
pyenv global 3.11.5
echo 'eval "$(pyenv init --path)"' >> $HOME/.build_env
pyenv init --path

# Prepare Python
python --version
pip3 install six --break-system-packages

# Define build folders
swift_source=$HOME/swift-source
mkdir -p $swift_source
echo "export SWIFT_SRC=$swift_source" >> $HOME/.build_env
