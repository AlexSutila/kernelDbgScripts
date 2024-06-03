`sudo apt-get install qemu-system`

## Scripts
| Script | Purpose |
|----------|----------|
| mkrootfs.sh | The purpose of this script is to throw together a compressed rootfs, `rootfs.cpio.gz`, which will be supplied to qemu as the initial ram disk. For the time being, this script uses busybox to do this. |
| startqemu.sh | Starts QEMU in a suspended state, where it will wait for you to attach GDB to it remotely. If `rootfs.cpio.gz` has yet to be generated, see 'mkrootfs.sh'|
| startgdb.sh | Run after starting QEMU (or running `startqemu.sh`). In the kernel source, there are helper scripts to simplify kernel debugging in GDB which are also loaded up as well. |

## Creating rootfs
### Busybox Compilation
Running `mkrootfs.sh` should provide a sufficient `rootfs.cpio.gz` to at least get something that boots. As mentioned earlier, `mkrootfs.sh` uses and builds busybox from source and then makes the necessary directory structure needed to boot. A menuconfig menu will apear during this process, be sure to compile it as a static binary (see below).
![image](https://github.com/AlexSutila/kernelDbgScripts/assets/96510931/bb4abd80-e312-4eb6-94e5-c6c96777aec8)
![image](https://github.com/AlexSutila/kernelDbgScripts/assets/96510931/e837ab22-5032-465d-8f14-eea975832fbd)
If extra stuff is needed, it can be copied into the rootfs folder before it is compressed. Life will be a lot easier if binaries copied into the rootfs can be compiled from source as static binaries.

## Additional Notes
### During kernel compilation
Compile the kernel with the following flags set as follows (or make sure they are set as follows by inspecting the config file on an already compiled kernel):
| Flag | Value |
|----------|----------|
| CONFIG_DEBUG_INFO | y |
| CONFIG_GDB_SCRIPTS | y |
| CONFIG_KGDB | y |
### After kernel compilation
Run `make scripts_gdb` in the kernel source root.
### During debugging
Once in GDB, the `lx-symbols` is particularly useful for refreshing debug symbols as you load (or unload) modules while in QEMU.
#### Loading a dummy hello world module
![image](https://github.com/AlexSutila/kernelDbgScripts/assets/96510931/0602ee0f-9e64-4014-b00f-b5ae778235cb)
#### Reloading debug symbols
![image](https://github.com/AlexSutila/kernelDbgScripts/assets/96510931/ad9c1249-c8fe-4497-8d8a-36bfa5b9799b)
