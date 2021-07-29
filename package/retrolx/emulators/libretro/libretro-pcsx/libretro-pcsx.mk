################################################################################
#
# PCSXREARMED
#
################################################################################
# Version.: Commits on Jul 21, 2021
LIBRETRO_PCSX_VERSION = 58e8d0a271aa19f210cc3acb71a1c8c4fc546a50
LIBRETRO_PCSX_SITE = $(call github,libretro,pcsx_rearmed,$(LIBRETRO_PCSX_VERSION))
LIBRETRO_PCSX_LICENSE = GPLv2

LIBRETRO_PCSX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_PCSX_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-pcsx

LIBRETRO_PCSX_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S922X),y)
LIBRETRO_PCSX_PLATFORM = CortexA73_G12B

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI4),y)
LIBRETRO_PCSX_PLATFORM = rpi4_64

else ifeq ($(BR2_aarch64),y)
LIBRETRO_PCSX_PLATFORM = unix

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_LIBRETECH_H5),y)
LIBRETRO_PCSX_PLATFORM = h5

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI3),y)
    ifeq ($(BR2_aarch64),y)
        LIBRETRO_PCSX_PLATFORM = rpi3_64
    else
        LIBRETRO_PCSX_PLATFORM = rpi3
    endif

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S812),y)
LIBRETRO_PCSX_PLATFORM = armv cortexa9 neon hardfloat

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_H3),y)
LIBRETRO_PCSX_PLATFORM = rpi2

endif

define LIBRETRO_PCSX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile.libretro platform="$(LIBRETRO_PCSX_PLATFORM)"
endef

define LIBRETRO_PCSX_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_PCSX_PKG_DIR)$(LIBRETRO_PCSX_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/pcsx_rearmed_libretro.so \
	$(LIBRETRO_PCSX_PKG_DIR)$(LIBRETRO_PCSX_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_PCSX_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-pcsx/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_PCSX_POST_INSTALL_TARGET_HOOKS = LIBRETRO_PCSX_MAKEPKG

$(eval $(generic-package))