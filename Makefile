LINUX_SRC := external/linux
LINUX_BUILD := build/linux
ARCH := x86_64
CROSS_COMPILE := x86_64-linux-gnu-
BZIMAGE := $(LINUX_BUILD)/arch/x86/boot/bzImage
JOBS ?= $(shell getconf _NPROCESSORS_ONLN 2>/dev/null || nproc 2>/dev/null || echo 1)
KERNEL_MAKE := $(MAKE) -C $(LINUX_SRC) O=$(abspath $(LINUX_BUILD)) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)

.PHONY: kernel bzImage kernel-config clean

kernel: bzImage

bzImage: $(BZIMAGE)

$(BZIMAGE): $(LINUX_BUILD)/.config
	$(KERNEL_MAKE) -j$(JOBS) bzImage

kernel-config: $(LINUX_BUILD)/.config

$(LINUX_BUILD)/.config:
	mkdir -p $(LINUX_BUILD)
	$(KERNEL_MAKE) x86_64_defconfig

clean:
	rm -rf build
