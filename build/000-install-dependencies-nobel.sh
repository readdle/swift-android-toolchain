#!/bin/bash
set -ex

cd $HOME

# Copied from https://github.com/swiftlang/swift-docker/blob/main/swift-ci/main/ubuntu/24.04/Dockerfile
DEBIAN_FRONTEND="noninteractive"

apt-get -y update && apt-get -q install -y \
    binutils \
    git \
    unzip \
    gnupg2 \
    libc6-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libgcc-13-dev \
    libpython3-dev \
    libsqlite3-0 \
    libstdc++-13-dev \
    libxml2-dev \
    libncurses-dev \
    libz3-dev \
    pkg-config \
    tzdata \
    zlib1g-dev

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

# Swiftly dependency
apt-get install -y \
  gnupg2 \
  jq

clang --version
  