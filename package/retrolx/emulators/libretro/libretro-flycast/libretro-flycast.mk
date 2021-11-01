################################################################################
#
# LIBRETRO-FLYCAST
#
################################################################################
# Version.: Commits on Oct 4, 2021
LIBRETRO_FLYCAST_VERSION = 4a913e063c95d1fae98afc64645831de0bcad57e
LIBRETRO_FLYCAST_SITE = $(call github,libretro,flycast,$(LIBRETRO_FLYCAST_VERSION))
LIBRETRO_FLYCAST_LICENSE = GPLv2

LIBRETRO_FLYCAST_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FLYCAST_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-flycast

LIBRETRO_FLYCAST_PLATFORM = $(LIBRETRO_PLATFORM)
LIBRETRO_FLYCAST_EXTRA_ARGS = HAVE_OPENMP=1

# LIBRETRO_PLATFORM is not good for this core, because
# for rpi, it contains "unix rpi" and this core do an "if unix elif rpi ..."

# special cases for special plateform then...
# an other proper way may be to redo the Makefile to do "if rpi elif unix ..." (from specific to general)
# the Makefile imposes that the platform has gles (or force FORCE_GLES is set) to not link with lGL

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_FLYCAST_PLATFORM = rpi-rpi4_64
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
    ifeq ($(BR2_aarch64),y)
        LIBRETRO_FLYCAST_PLATFORM = rpi-rpi3_64
        LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64
    else
        LIBRETRO_FLYCAST_PLATFORM = rpi-rpi3
        LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm FORCE_GLES=1 LDFLAGS=-lrt
    endif

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_EXYNOS5422),y)
LIBRETRO_FLYCAST_PLATFORM = odroid
LIBRETRO_FLYCAST_EXTRA_ARGS += BOARD=ODROID-XU4 FORCE_GLES=1 ARCH=arm

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_H5),y)
LIBRETRO_FLYCAST_PLATFORM = h5
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64 FORCE_GLES=1 LDFLAGS=-lrt

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_H6),y)
LIBRETRO_FLYCAST_PLATFORM = h5
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64 FORCE_GLES=1 LDFLAGS=-lrt

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_H616),y)
LIBRETRO_FLYCAST_PLATFORM = h616
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64 FORCE_GLES=1 LDFLAGS=-lrt

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905),y)
LIBRETRO_FLYCAST_PLATFORM = AMLGX
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64 FORCE_GLES=1 LDFLAGS=-lrt

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905GEN2),y)
LIBRETRO_FLYCAST_PLATFORM = AMLGXM
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64 FORCE_GLES=1 LDFLAGS=-lrt

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905GEN3),y)
LIBRETRO_FLYCAST_PLATFORM = odroidc4
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64 FORCE_GLES=1 LDFLAGS=-lrt

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3328),y)
LIBRETRO_FLYCAST_PLATFORM = rk3328
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64 FORCE_GLES=1 LDFLAGS=-lrt

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK356X),y)
LIBRETRO_FLYCAST_PLATFORM = rk356x
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64 FORCE_GLES=1 LDFLAGS=-lrt

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
LIBRETRO_FLYCAST_PLATFORM = rpi-rpi4_64
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64 FORCE_GLES=1 LDFLAGS=-lrt

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
LIBRETRO_FLYCAST_PLATFORM = odroid-n2
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64 FORCE_GLES=1 LDFLAGS=-lrt

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3326),y)
ifeq ($(BR2_arm),y)
LIBRETRO_FLYCAST_PLATFORM = classic_armv8_a35
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm FORCE_GLES=1 LDFLAGS=-lrt
else
LIBRETRO_FLYCAST_PLATFORM = arm64
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm64 FORCE_GLES=1 LDFLAGS=-lrt
endif

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_AW32),y)
LIBRETRO_FLYCAST_PLATFORM = sun8i
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm FORCE_GLES=1 LDFLAGS=-lrt

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_FLYCAST_PLATFORM = odroid
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm FORCE_GLES=1 LDFLAGS=-lrt

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3288),y)
LIBRETRO_FLYCAST_PLATFORM = tinkerboard
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=arm

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86),y)
LIBRETRO_FLYCAST_EXTRA_ARGS += ARCH=x86
endif

define LIBRETRO_FLYCAST_BUILD_CMDS
    $(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile \
		platform="$(LIBRETRO_FLYCAST_PLATFORM)" $(LIBRETRO_FLYCAST_EXTRA_ARGS)
endef

define LIBRETRO_FLYCAST_INSTALL_TARGET_CMDS
	echo "lr-flycast built as package, no rootfs install"
endef

define LIBRETRO_FLYCAST_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_FLYCAST_PKG_DIR)$(LIBRETRO_FLYCAST_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/flycast_libretro.so \
	$(LIBRETRO_FLYCAST_PKG_DIR)$(LIBRETRO_FLYCAST_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_FLYCAST_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-flycast/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FLYCAST_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FLYCAST_MAKEPKG

$(eval $(generic-package))
