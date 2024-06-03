#!/bin/bash

# The purpose of this script is to throw together a compressed rootfs which
# will be supplied to qemu as the initial ram disk. For the time being I'm
# using busybox to do this. The only reason why this script needs to be run
# as root is because of mknod usage for tty devices.

NRCORES=4

wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2
tar -xf busybox-1.36.1.tar.bz2 && rm busybox-1.36.1.tar.bz2

# !!! Compiling Busybox - IMPORTANT !!!
# When compiling busybox, make sure that the option "Build static binary"
# is set during the menuconfig. This can be found under settings and then
# under build options
pushd busybox-1.36.1/ > /dev/null
make menuconfig && make -j "$NRCORES" && make install -j "$NRCORES"
popd > /dev/null

# Genrating rootfs
mkdir -p rootfs/{bin,dev,etc,proc,sbin,sys,usr/{bin,sbin}}
cp -a ~/busybox-1.36.1/_install/* rootfs/
pushd rootfs/ > /dev/null

pushd dev/ > /dev/null
echo "NOTE: sudo is only needed for making character devices"
sudo sh -c 'mknod -m 660 mem c 1 1
	mknod -m 660 ttyS0 c 4 0
	mknod -m 660 tty2 c 4 2
	mknod -m 660 tty3 c 4 3
	mknod -m 660 tty4 c 4 4'
popd > /dev/null

ln -sf bin/busybox init
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../rootfs.cpio.gz
popd > /dev/null

# !!! HERE !!!
# If anything else needs to be copied over, this is the place to do it. For
# example, if I want to load and debug a kernel module the .ko can be moved
# or copied into rootfs and loaded once qemu has been started.

echo "Done"
