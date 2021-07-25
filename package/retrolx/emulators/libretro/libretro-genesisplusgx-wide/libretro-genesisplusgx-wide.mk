################################################################################
#
# GENESISPLUSGX-WIDE
#
################################################################################
# Version.: Commits on Apr 09, 2021
LIBRETRO_GENESISPLUSGX_WIDE_VERSION = 73c298b106610055be4bffd4f5eb996c6bf83aee
LIBRETRO_GENESISPLUSGX_WIDE_SITE = $(call github,libretro,Genesis-Plus-GX-Wide,$(LIBRETRO_GENESISPLUSGX_WIDE_VERSION))
LIBRETRO_GENESISPLUSGX_WIDE_LICENSE = Non-commercial

LIBRETRO_GENESISPLUSGX_WIDE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_GENESISPLUSGX_WIDE_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-genesisplusgx-wide

LIBRETRO_GENESISPLUSGX_WIDE_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S922X),y)
	LIBRETRO_GENESISPLUSGX_WIDE_PLATFORM += CortexA73_G12B
endif

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_ORANGEPI_PC),y)
	LIBRETRO_GENESISPLUSGX_WIDE_PLATFORM += rpi2
endif

define LIBRETRO_GENESISPLUSGX_WIDE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile.libretro platform="$(LIBRETRO_GENESISPLUSGX_WIDE_PLATFORM)"
endef

define LIBRETRO_GENESISPLUSGX_WIDE_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_GENESISPLUSGX_WIDE_PKG_DIR)$(LIBRETRO_GENESISPLUSGX_WIDE_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/genesis_plus_gx_wide_libretro.so \
	$(LIBRETRO_GENESISPLUSGX_WIDE_PKG_DIR)$(LIBRETRO_GENESISPLUSGX_WIDE_PKG_INSTALL_DIR)/genesisplusgx-wide_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_GENESISPLUSGX_WIDE_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-genesisplusgx-wide/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_GENESISPLUSGX_WIDE_POST_INSTALL_TARGET_HOOKS = LIBRETRO_GENESISPLUSGX_WIDE_MAKEPKG

$(eval $(generic-package))
