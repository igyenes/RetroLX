################################################################################
#
# BEETLE_PCE_FAST
#
################################################################################
# Version.: Commits on Jul 23, 2021
LIBRETRO_BEETLE_PCE_FAST_VERSION = a10cb17de6161ec92c7958f806eb6d0d29eed656
LIBRETRO_BEETLE_PCE_FAST_SITE = $(call github,libretro,beetle-pce-fast-libretro,$(LIBRETRO_BEETLE_PCE_FAST_VERSION))
LIBRETRO_BEETLE_PCE_FAST_LICENSE = GPLv2

LIBRETRO_BEETLE_PCE_FAST_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BEETLE_PCE_FAST_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-beetle-pce-fast

define LIBRETRO_BEETLE_PCE_FAST_BUILD_CMDS
    $(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BEETLE_PCE_FAST_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BEETLE_PCE_FAST_PKG_DIR)$(LIBRETRO_BEETLE_PCE_FAST_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mednafen_pce_fast_libretro.so \
	$(LIBRETRO_BEETLE_PCE_FAST_PKG_DIR)$(LIBRETRO_BEETLE_PCE_FAST_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_BEETLE_PCE_FAST_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-beetle-pce-fast/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BEETLE_PCE_FAST_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BEETLE_PCE_FAST_MAKEPKG

$(eval $(generic-package))