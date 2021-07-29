################################################################################
#
# LIBRETRO_FREEINTV
#
################################################################################
# Version.: Commits on May 12, 2021
LIBRETRO_FREEINTV_VERSION = 5fc8d85ee9699baaaf0c63399c364f456097fc1e
LIBRETRO_FREEINTV_SITE = $(call github,libretro,freeintv,$(LIBRETRO_FREEINTV_VERSION))
LIBRETRO_FREEINTV_LICENSE = GPLv3

LIBRETRO_FREEINTV_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FREEINTV_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-freeintv

define LIBRETRO_FREEINTV_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile platform="unix"
endef

define LIBRETRO_FREEINTV_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_FREEINTV_PKG_DIR)$(LIBRETRO_FREEINTV_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/freeintv_libretro.so \
	$(LIBRETRO_FREEINTV_PKG_DIR)$(LIBRETRO_FREEINTV_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_FREEINTV_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-freeintv/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FREEINTV_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FREEINTV_MAKEPKG

$(eval $(generic-package))