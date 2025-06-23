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
  