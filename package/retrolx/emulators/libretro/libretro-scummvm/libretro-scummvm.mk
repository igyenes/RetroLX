################################################################################
#
# SCUMMVM
#
################################################################################
# Version.: Commits on Aug 9, 2022
LIBRETRO_SCUMMVM_VERSION = 582ff3009fe7bf339f9340f5b3a441a6bd46a099
LIBRETRO_SCUMMVM_SITE = https://github.com/rtissera/scummvm
LIBRETRO_SCUMMVM_SITE_METHOD=git
LIBRETRO_SCUMMVM_GIT_SUBMODULES=YES
LIBRETRO_SCUMMVM_LICENSE = GPLv2

LIBRETRO_SCUMMVM_PLATFORM = $(LIBRETRO_PLATFORM)

LIBRETRO_SCUMMVM_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_SCUMMVM_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-scummvm


ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_SCUMMVM_PLATFORM = armv cortexa9 neon hardfloat

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_SCUMMVM_PLATFORM = rpi3

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_SCUMMVM_PLATFORM = rpi4

else ifeq ($(BR2_aarch64)$(BR2_x86_64),y)
LIBRETRO_SCUMMVM_PLATFORM = unix
LIBRETRO_SCUMMVM_MAKE_OPTS += TARGET_64BIT=1
endif

define LIBRETRO_SCUMMVM_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/backends/platform/libretro/build platform="$(LIBRETRO_SCUMMVM_PLATFORM)" $(LIBRETRO_SCUMMVM_MAKE_OPTS)
endef

define LIBRETRO_SCUMMVM_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_SCUMMVM_PKG_DIR)$(LIBRETRO_SCUMMVM_PKG_INSTALL_DIR)/

	# Copy package files
	cp -pr $(@D)/backends/platform/libretro/build/scummvm_libretro.so \
	$(LIBRETRO_SCUMMVM_PKG_DIR)$(LIBRETRO_SCUMMVM_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_SCUMMVM_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-scummvm/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_SCUMMVM_POST_INSTALL_TARGET_HOOKS = LIBRETRO_SCUMMVM_MAKEPKG

$(eval $(generic-package))
