#!/usr/bin/env bash

set -

base_dir=$(readlink -nf $(dirname $0)/../..)
source "$base_dir/lib/prelude_apply.bash"
source "$base_dir/etc/settings.bash"

mkdir "$chroot/usr/src/ixgbevf-4.6.1"

tar -xzf "$assets_dir/ixgbevf-4.6.1.tar.gz" \
  -C "$chroot/usr/src/ixgbevf-4.6.1" \
  --strip-components=1

cp $assets_dir/usr/src/ixgbevf-4.6.1/dkms.conf $chroot/usr/src/ixgbevf-4.6.1/dkms.conf

pkg_mgr install dkms

kernelver=$(ls -rt "$chroot/lib/modules" | tail -1)
run_in_chroot "$chroot" "dkms -k ${kernelver} add -m ixgbevf -v 4.6.1"
run_in_chroot "$chroot" "dkms -k ${kernelver} build -m ixgbevf -v 4.6.1"
run_in_chroot "$chroot" "dkms -k ${kernelver} install -m ixgbevf -v 4.6.1"

run_in_chroot "$chroot" "dracut --force --kver ${kernelver}"
