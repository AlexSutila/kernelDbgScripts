#!/bin/bash

# Starts QEMU in a suspended state, where it will wait for you to attach GDB
# to it remotely. If rootfs.cpio.gz has yet to be generated, see 'mkrootfs.sh'

if [ $# -lt 2 ]; then
	echo "Usage: $0 <Path to bzImage> <Path to rootfs>"
	exit 1
fi

BZIMAGE_PATH="$1"
ROOTFS_PATH="$2" # path to rootfs.cpio.gz
MEM="512M"
#qemu-system-x86_64 -s -S -M pc -m "$MEM" -kernel "$BZIMAGE_PATH" 	\
qemu-system-x86_64 -M pc -m "$MEM" -kernel "$BZIMAGE_PATH" 	\
	-initrd "$ROOTFS_PATH" 						\
	-append "root=/dev/mem console=ttyS0 nokaslr"			\
	-nographic
