################################################################################
#
# MELONDS
#
################################################################################
# Version.: Commits on Apr 11, 2021
LIBRETRO_MELONDS_VERSION = 657c729e7473e9b2c09ddf2eef9dcf4ba5b247ec
LIBRETRO_MELONDS_SITE = $(call github,libretro,melonds,$(LIBRETRO_MELONDS_VERSION))
LIBRETRO_MELONDS_LICENSE = GPLv2
LIBRETRO_MELONDS_DEPENDENCIES = libpcap retroarch

LIBRETRO_MELONDS_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_MELONDS_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-melonds

LIBRETRO_MELONDS_PLATFORM = $(LIBRETRO_PLATFORM)
LIBRETRO_MELONDS_EXTRA_ARGS =

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI4),y)
LIBRETRO_MELONDS_PLATFORM = rpi4_64

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S905GEN3),y)
LIBRETRO_MELONDS_PLATFORM = odroidc4

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3326),y)
LIBRETRO_MELONDS_PLATFORM = odroidgoa

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S912)$(BR2_PACKAGE_BATOCERA_TARGET_H616),y)
LIBRETRO_MELONDS_PLATFORM = orangepizero2

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S922X),y)
LIBRETRO_MELONDS_PLATFORM = odroidn2

else ifeq ($(BR2_aarch64),y)
LIBRETRO_MELONDS_PLATFORM = unix

else ifeq ($(BR2_x86_64),y)
LIBRETRO_MELONDS_EXTRA_ARGS += ARCH=x86_64
endif

define LIBRETRO_MELONDS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) LDFLAGS="-lrt" CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_MELONDS_PLATFORM)" $(LIBRETRO_MELONDS_EXTRA_ARGS)
endef

define LIBRETRO_MELONDS_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_MELONDS_PKG_DIR)$(LIBRETRO_MELONDS_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/melonds_libretro.so \
	$(LIBRETRO_MELONDS_PKG_DIR)$(LIBRETRO_MELONDS_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_MELONDS_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-melonds/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_MELONDS_POST_INSTALL_TARGET_HOOKS = LIBRETRO_MELONDS_MAKEPKG

$(eval $(generic-package))
