LINUX_SRC := external/linux
LINUX_BUILD := build/linux
ARCH := x86_64
CROSS_COMPILE := x86_64-linux-gnu-
BZIMAGE := $(LINUX_BUILD)/arch/x86/boot/bzImage
BUSYBOX_SRC := external/busybox
BUSYBOX_BUILD := build/busybox
BUSYBOX_INSTALL := build/rootfs
BUSYBOX_CONFIG := $(BUSYBOX_BUILD)/.config
BUSYBOX_CONFIG_STAMP := $(BUSYBOX_BUILD)/.config.runix
BUSYBOX_BUILD_STAMP := $(BUSYBOX_BUILD)/.built
JOBS ?= $(shell getconf _NPROCESSORS_ONLN 2>/dev/null || nproc 2>/dev/null || echo 1)
KERNEL_MAKE := $(MAKE) -C $(LINUX_SRC) O=$(abspath $(LINUX_BUILD)) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)
BUSYBOX_MAKE := $(MAKE) -C $(BUSYBOX_SRC) O=$(abspath $(BUSYBOX_BUILD)) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)

.PHONY: kernel bzImage kernel-config busybox busybox-config busybox-install clean

kernel: bzImage

bzImage: $(BZIMAGE)

$(BZIMAGE): $(LINUX_BUILD)/.config
	$(KERNEL_MAKE) -j$(JOBS) bzImage

kernel-config: $(LINUX_BUILD)/.config

$(LINUX_BUILD)/.config:
	mkdir -p $(LINUX_BUILD)
	$(KERNEL_MAKE) x86_64_defconfig

busybox: $(BUSYBOX_BUILD_STAMP)

$(BUSYBOX_BUILD_STAMP): $(BUSYBOX_CONFIG_STAMP)
	$(BUSYBOX_MAKE) -j$(JOBS)
	touch $(BUSYBOX_BUILD_STAMP)

$(BUSYBOX_CONFIG):
	mkdir -p $(BUSYBOX_BUILD)
	$(BUSYBOX_MAKE) defconfig

$(BUSYBOX_CONFIG_STAMP):
	$(MAKE) $(BUSYBOX_CONFIG)
	sed -i -e 's/^# CONFIG_STATIC is not set/CONFIG_STATIC=y/' $(BUSYBOX_CONFIG)
	sed -i -e 's/^CONFIG_TC=y/# CONFIG_TC is not set/' $(BUSYBOX_CONFIG)
	touch $(BUSYBOX_CONFIG_STAMP)

busybox-install: busybox
	$(BUSYBOX_MAKE) CONFIG_PREFIX=$(abspath $(BUSYBOX_INSTALL)) install

clean:
	rm -rf build
