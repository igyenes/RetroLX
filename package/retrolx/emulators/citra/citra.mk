################################################################################
#
# CITRA
#
################################################################################
# Version.: Commits on Nov 20, 2021

CITRA_DEPENDENCIES = fmt boost ffmpeg sdl2 fdk-aac
CITRA_SITE_METHOD=git
CITRA_GIT_SUBMODULES=YES
CITRA_LICENSE = GPLv2

CITRA_PKG_DIR = $(TARGET_DIR)/opt/retrolx/citra
CITRA_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/citra

# commit 55ec7031ccb2943c2c507620cf4613a86d160670 is reverted by patch, something wrong in it for perfs (patch 004-perf1-revert-core.patch)
# patch 003-perf1.patch while NO_CAST_FROM_ASCII is causing perfs issues too
CITRA_VERSION = 64b502aad36a22a98e7adf69a1293b524e571125
CITRA_SITE = https://github.com/citra-emu/citra.git
CITRA_CONF_OPTS += -DENABLE_QT=ON
CITRA_CONF_OPTS += -DENABLE_QT_TRANSLATION=ON
CITRA_CONF_OPTS += -DARCHITECTURE=x86_64
CITRA_DEPENDENCIES += qt5base qt5tools qt5multimedia

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
CITRA_SUPPORTS_IN_SOURCE_BUILD = NO

CITRA_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
CITRA_CONF_OPTS += -DENABLE_WEB_SERVICE=OFF
CITRA_CONF_OPTS += -DENABLE_FFMPEG=ON
CITRA_CONF_OPTS += -DBUILD_SHARED_LIBS=FALSE
CITRA_CONF_OPTS += -DENABLE_FFMPEG_AUDIO_DECODER=ON

CITRA_CONF_ENV += LDFLAGS=-lpthread

define CITRA_INSTALL_TARGET_CMDS
	echo "Daphne built as pacman package, no rootfs install"
endef

define CITRA_MAKEPKG
	# Create directories
	mkdir -p $(CITRA_PKG_DIR)$(CITRA_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/buildroot-build/bin/Release/citra-qt \
	$(CITRA_PKG_DIR)$(CITRA_PKG_INSTALL_DIR)	
	cp -prn $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/citra/3ds.citra.keys \
	$(CITRA_PKG_DIR)$(CITRA_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(CITRA_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/citra/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

CITRA_POST_INSTALL_TARGET_HOOKS = CITRA_MAKEPKG

$(eval $(cmake-package))
