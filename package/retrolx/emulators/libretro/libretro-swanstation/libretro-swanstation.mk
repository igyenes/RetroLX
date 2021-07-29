################################################################################
#
# LIBRETRO_SWANSTATION
#
################################################################################
# Version.: Commits on Jun 02, 2021
LIBRETRO_SWANSTATION_VERSION = 50a6a5e73d57201c509c28e6842a28f9d371ab17
LIBRETRO_SWANSTATION_SITE = $(call github,libretro,swanstation,$(LIBRETRO_SWANSTATION_VERSION))
LIBRETRO_SWANSTATION_LICENSE = GPLv2
LIBRETRO_SWANSTATION_DEPENDENCIES = fmt boost ffmpeg

LIBRETRO_SWANSTATION_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_SWANSTATION_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-swanstation

LIBRETRO_SWANSTATION_CONF_OPTS  = -DCMAKE_BUILD_TYPE=Release
LIBRETRO_SWANSTATION_CONF_OPTS += -DBUILD_SHARED_LIBS=FALSE
LIBRETRO_SWANSTATION_CONF_OPTS += -DBUILD_LIBRETRO_CORE=ON
LIBRETRO_SWANSTATION_CONF_OPTS += -DUSE_DRMKMS=ON

LIBRETRO_SWANSTATION_CONF_ENV += LDFLAGS=-lpthread

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
LIBRETRO_SWANSTATION_SUPPORTS_IN_SOURCE_BUILD = NO

define LIBRETRO_SWANSTATION_INSTALL_TARGET_CMDS
	echo "lr-swanstation build as pacman package, no rootfs install"
endef

define LIBRETRO_SWANSTATION_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_SWANSTATION_PKG_DIR)$(LIBRETRO_SWANSTATION_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/buildroot-build/swanstation_libretro.so \
	$(LIBRETRO_SWANSTATION_PKG_DIR)$(LIBRETRO_SWANSTATION_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_SWANSTATION_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-swanstation/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_SWANSTATION_POST_INSTALL_TARGET_HOOKS = LIBRETRO_SWANSTATION_MAKEPKG

$(eval $(cmake-package))