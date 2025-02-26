#!/bin/bash
set -ex

cd $HOME

# Copied from https://github.com/swiftlang/swift-docker/blob/main/swift-ci/main/ubuntu/24.04/Dockerfile
DEBIAN_FRONTEND="noninteractive"

apt-get -y update && apt-get -y install \
  build-essential       \
  clang                 \
  cmake                 \
  git                   \
  icu-devtools          \
  libc++-18-dev         \
  libc++abi-18-dev      \
  libcurl4-openssl-dev  \
  libedit-dev           \
  libicu-dev            \
  libncurses5-dev       \
  libpython3-dev        \
  libsqlite3-dev        \
  libxml2-dev           \
  ninja-build           \
  pkg-config            \
  python3-six           \
  python3-pip           \
  python3-pkg-resources \
  python3-psutil        \
  python3-setuptools    \
  rsync                 \
  swig                  \
  systemtap-sdt-dev     \
  tzdata                \
  uuid-dev              \
  zip

apt-get install -y  \
    lsb-release                 \
    software-properties-common  \
    gnupg                       \
    autoconf                    \
    automake                    \
    libtool                     \
    curl                        \
    wget                        \
    unzip                       \
    vim                         \
    rpl

clang --version

# Install swift for bootstraping
wget https://download.swift.org/swift-6.0.3-release/ubuntu2004/swift-6.0.3-RELEASE/swift-6.0.3-RELEASE-ubuntu20.04.tar.gz
tar -xvzf swift-6.0.3-RELEASE-ubuntu20.04.tar.gz
rm swift-6.0.3-RELEASE-ubuntu20.04.tar.gz
mv $HOME/swift-6.0.3-RELEASE-ubuntu20.04 $HOME/swift-toolchain
export PATH=$HOME/swift-toolchain/usr/bin:$PATH
echo "export PATH=\$HOME/swift-toolchain/usr/bin:\$PATH" >> .build_env
echo "export SWIFT_PATH=\$HOME/swift-toolchain/usr/bin" >> .build_env

swift --version
  