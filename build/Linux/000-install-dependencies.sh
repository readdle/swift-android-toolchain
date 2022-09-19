#!/bin/bash
set -ex

apt-get update

apt-get install -y      \
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

apt-get install -y \
    autoconf automake libtool curl wget unzip vim rpl python3-pip

pip3 install --upgrade cmake==3.20.2

ln -s /usr/bin/perl /usr/local/bin/perl

# Starting from Ubuntu 20.04 Python 3 is default Python
# https://wiki.ubuntu.com/FocalFossa/ReleaseNotes#Python3_by_default
# But all swift build script rely on /usr/bin/python which should be Python2

# Prinnt current version of /usr/bin/python
/usr/bin/python --version

# Install Python 2
apt install python2

# Print version of Python2 and Python3
python2 --version
python3 --version

update-alternatives --install /usr/bin/python python /usr/bin/python2 1

# Prinnt current version of /usr/bin/python
/usr/bin/python --version

# Install python packages
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python get-pip.py
pip2 install six
