#!/bin/bash
sudo apt-get -y update

sudo apt-get install -y      \
  clang                 \
  cmake                 \
  git                   \
  icu-devtools          \
  libblocksruntime-dev  \
  libbsd-dev            \
  libcurl4-openssl-dev  \
  libedit-dev           \
  libicu-dev            \
  libncurses5-dev       \
  libpython-dev         \
  libpython3-dev        \
  libsqlite3-dev        \
  libxml2-dev           \
  ninja-build           \
  pkg-config            \
  python                \
  python-six            \
  rsync                 \
  swig                  \
  systemtap-sdt-dev     \
  tzdata                \
  uuid-dev

sudo snap install sccache --candidate --classic

sudo apt-get install -y \
    autoconf automake libtool curl wget unzip vim rpl python3-pip

sudo pip3 install --upgrade cmake==3.18.4

sudo ln -s /usr/bin/perl /usr/local/bin/perl
