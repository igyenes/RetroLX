################################################################################
#
# FBNEO
#
################################################################################
# Version.: Commits on Aug 22, 2022
LIBRETRO_FBNEO_VERSION = 31280503a96528ae2a52c1acff5fe09aa11870bf
LIBRETRO_FBNEO_SITE = $(call github,libretro,FBNeo,$(LIBRETRO_FBNEO_VERSION))
LIBRETRO_FBNEO_LICENSE = Non-commercial

LIBRETRO_FBNEO_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FBNEO_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-fbneo

LIBRETRO_FBNEO_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_ARM_FPU_NEON_VFPV4)$(BR2_ARM_FPU_NEON)$(BR2_ARM_FPU_NEON_FP_ARMV8),y)
LIBRETRO_FBNEO_EXTRA_ARGS = HAVE_NEON=1 USE_CYCLONE=1 profile=performance
else
LIBRETRO_FBNEO_EXTRA_ARGS = HAVE_NEON=0 profile=accuracy
endif

ifeq ($(BR2_x86_64),y)
LIBRETRO_FBNEO_EXTRA_ARGS = USE_X64_DRC=1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM32_A7_GLES2),y)
LIBRETRO_FBNEO_PLATFORM = classic_armv7_a7
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3326),y)
LIBRETRO_FBNEO_EXTRA_ARGS = USE_EXPERIMENTAL_FLAGS=0
endif

define LIBRETRO_FBNEO_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/src/burner/libretro -f Makefile platform="$(LIBRETRO_FBNEO_PLATFORM)" $(LIBRETRO_FBNEO_EXTRA_ARGS) \
	GIT_VERSION=" $(shell echo $(LIBRETRO_FBNEO_VERSION) | cut -c 1-10)"
endef

define LIBRETRO_FBNEO_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_FBNEO_PKG_DIR)$(LIBRETRO_FBNEO_PKG_INSTALL_DIR)/bios/samples

	# Strip binary
	$(TARGET_STRIP) -s $(@D)/src/burner/libretro/fbneo_libretro.so

	# Copy package files
	$(INSTALL) -D $(@D)/src/burner/libretro/fbneo_libretro.so $(LIBRETRO_FBNEO_PKG_DIR)$(LIBRETRO_FBNEO_PKG_INSTALL_DIR)
	$(INSTALL) -D $(@D)/metadata/* $(LIBRETRO_FBNEO_PKG_DIR)$(LIBRETRO_FBNEO_PKG_INSTALL_DIR)/bios/
	$(INSTALL) -D $(@D)/dats/*.dat $(LIBRETRO_FBNEO_PKG_DIR)$(LIBRETRO_FBNEO_PKG_INSTALL_DIR)/bios/

	# Build Pacman package
	cd $(LIBRETRO_FBNEO_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-fbneo/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FBNEO_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FBNEO_MAKEPKG

$(eval $(generic-package))
