################################################################################
#
# ATARI800
#
################################################################################
# Version.: Commits on Jul 26, 2022
LIBRETRO_ATARI800_VERSION = 94033288b026fe699bc50703609807aa8075f4dd
LIBRETRO_ATARI800_SITE = $(call github,libretro,libretro-atari800,$(LIBRETRO_ATARI800_VERSION))
LIBRETRO_ATARI800_LICENSE = GPL

LIBRETRO_ATARI800_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_ATARI800_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-atari800

define LIBRETRO_ATARI800_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" GIT_VERSION="" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_ATARI800_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_ATARI800_PKG_DIR)$(LIBRETRO_ATARI800_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/atari800_libretro.so \
	$(LIBRETRO_ATARI800_PKG_DIR)$(LIBRETRO_ATARI800_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_ATARI800_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-atari800/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_ATARI800_POST_INSTALL_TARGET_HOOKS = LIBRETRO_ATARI800_MAKEPKG

$(eval $(generic-package))
