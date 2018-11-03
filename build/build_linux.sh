#!/bin/bash
set -e

SELF_DIR=$(dirname $0)
BASE_DIR=$SELF_DIR/../

pushd $BASE_DIR/vagrant
    vagrant up
    
    vagrant ssh -c /vagrant/scripts/010_build_libiconv_libicu.sh
    vagrant ssh -c /vagrant/scripts/020_clone_toolchain_swift.sh
    vagrant ssh -c /vagrant/scripts/030_build_swift_android.sh
    vagrant ssh -c /vagrant/scripts/040_build_corelibs_libdispatch.sh
    vagrant ssh -c /vagrant/scripts/050_build_foundation_depends.sh
    vagrant ssh -c /vagrant/scripts/060_build_corelibs_foundation.sh
    vagrant ssh -c /vagrant/scripts/070_build_corelibs_xctest.sh
    vagrant ssh -c /vagrant/scripts/080_collect_licenses.sh
    vagrant ssh -c /vagrant/scripts/090_install.sh

    vagrant halt
popd