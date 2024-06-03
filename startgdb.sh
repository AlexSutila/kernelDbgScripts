#!/bin/bash

# Run after starting QEMU

if [ $# -eq 0 ]; then
	echo "Usage: $0 <Path to kernel src root>"
	exit 1
fi

KERNEL_SRC_ROOT="${1%/}"
VMLINUX_PATH="$KERNEL_SRC_ROOT/vmlinux"
gdb "$VMLINUX_PATH" 					\
	-ex "add-auto-load-safe-path $KERNEL_SRC_ROOT" 	\
	-ex "source $KERNEL_SRC_ROOT/vmlinux-gdb.py"	\
	-ex "target remote localhost:1234"
