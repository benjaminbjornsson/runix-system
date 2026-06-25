# Runix System

Small Linux system build using an external Linux kernel tree, BusyBox, a generated initramfs cpio archive, and QEMU.

## Requirements

The easiest way to build is through the provided Docker image. It contains the cross compiler, BusyBox/kernel build dependencies, `cpio`, and QEMU.

Build the image once:

```sh
./scripts/docker-build.sh
```

Run commands inside it with:

```sh
./docker-run <command>
```

`docker-run` passes `-it` when stdin is a terminal, which is needed for interactive QEMU sessions.

## Build Targets

Build the kernel:

```sh
./docker-run make kernel
```

Build BusyBox and install it into `build/rootfs`:

```sh
./docker-run make busybox-install
```

Create the initramfs archive:

```sh
./docker-run make rootfs-cpio
```

This writes:

```text
build/rootfs.cpio
```

The archive is created with `newc` format and root-owned entries:

```sh
find . | sort | cpio -o -H newc --owner=0:0
```

## Run In QEMU

Build what is needed and boot the system:

```sh
./docker-run make qemu-run
```

The default QEMU command uses the kernel at `build/linux/arch/x86/boot/bzImage`, the initramfs at `build/rootfs.cpio`, and serial stdio:

```text
console=ttyS0 rdinit=/init
```

After boot, `/init` mounts basic virtual filesystems and starts BusyBox `sh` through `cttyhack`.

To exit from inside the guest:

```sh
poweroff -f
```

If QEMU itself needs to be terminated from the host terminal, use `Ctrl-c`.

## Rootfs Init

The init script is tracked at:

```text
rootfs/init
```

It is copied into `build/rootfs/init` during `make busybox-install`. The rootfs install and BusyBox build use stamp files so repeated `make qemu-run` invocations do not rebuild everything unless inputs changed.

## Clean

Remove all build outputs:

```sh
./docker-run make clean
```
