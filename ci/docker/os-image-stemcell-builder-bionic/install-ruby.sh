#!/bin/bash

set -e
set -x

CHRUBY_VER="0.3.9"
CHRUBY_URL=https://github.com/postmodern/chruby/archive/v${CHRUBY_VER}.tar.gz
RUBY_INSTALL_VER="0.5.0"
RUBY_INSTALL_URL=https://github.com/postmodern/ruby-install/archive/v${RUBY_INSTALL_VER}.tar.gz

echo "Installing chruby v${CHRUBY_VER}..."
wget -O chruby-${CHRUBY_VER}.tar.gz https://github.com/postmodern/chruby/archive/v${CHRUBY_VER}.tar.gz
tar -xzvf chruby-${CHRUBY_VER}.tar.gz
cd chruby-${CHRUBY_VER}/
scripts/setup.sh
cd ..
rm -rf chruby-${CHRUBY_VER}/
rm chruby-${CHRUBY_VER}.tar.gz

echo "Installing ruby-install v${RUBY_INSTALL_VER}..."
wget -O ruby-install-${RUBY_INSTALL_VER}.tar.gz $RUBY_INSTALL_URL
tar -xzvf ruby-install-${RUBY_INSTALL_VER}.tar.gz
cd ruby-install-${RUBY_INSTALL_VER}/
make install
cd ..
rm -rf ruby-install-${RUBY_INSTALL_VER}/
rm ruby-install-${RUBY_INSTALL_VER}.tar.gz

install_ruby() {
    local version=$1
    local sha=$2

    echo "Installing ruby $version..."
    ruby-install --cleanup --sha256 "$sha" ruby "$version"

    source /etc/profile.d/chruby.sh

    chruby "ruby-$version"
    ruby -v
    gem update --system
    gem install bundler:1.17.3  # gem update --system now installs bundler v2.x, but we're still using 1.x in our lockfile for now
}

install_ruby 2.4.5 276c8e73e51e4ba6a0fe81fb92669734e741ccea86f01c45e99f2c7ef7bcd1e3
