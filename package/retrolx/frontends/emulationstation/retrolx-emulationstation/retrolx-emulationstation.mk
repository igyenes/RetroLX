################################################################################
#
# RetroLX Emulation Station
#
################################################################################

RETROLX_EMULATIONSTATION_VERSION = a4b49683716094dc73cf3a1a4abc19c29bb87685
RETROLX_EMULATIONSTATION_SITE = https://github.com/RetroLX/retrolx-emulationstation
RETROLX_EMULATIONSTATION_SITE_METHOD = git
RETROLX_EMULATIONSTATION_LICENSE = MIT
RETROLX_EMULATIONSTATION_GIT_SUBMODULES = YES
RETROLX_EMULATIONSTATION_LICENSE = MIT, Apache-2.0
RETROLX_EMULATIONSTATION_DEPENDENCIES = sdl2 sdl2_mixer freetype alsa-lib libcurl gstreamer1 rapidjson libyuv
# install in staging for debugging (gdb)
RETROLX_EMULATIONSTATION_INSTALL_STAGING = YES
# RETROLX_EMULATIONSTATION_OVERRIDE_SRCDIR = /sources/batocera-emulationstation

RETROLX_EMULATIONSTATION_PKG_DIR = $(TARGET_DIR)/opt/retrolx/emulationstation
RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/emulationstation

RETROLX_EMULATIONSTATION_CONF_OPTS += -DCMAKE_CXX_FLAGS=-D$(call UPPERCASE,$(RETROLX_SYSTEM_ARCH)) -DCMAKE_BUILD_TYPE=Release

ifeq ($(BR2_PACKAGE_PUGIXML),y)
RETROLX_EMULATIONSTATION_CONF_OPTS += -DUSE_SYSTEM_PUGIXML=ON
endif

ifeq ($(BR2_PACKAGE_LIBYUV),y)
RETROLX_EMULATIONSTATION_CONF_OPTS += -DUSE_SYSTEM_LIBYUV=ON
endif

RETROLX_EMULATIONSTATION_CONF_OPTS += -DUSE_GSTREAMER=ON -DUSE_VLC=OFF

ifeq ($(BR2_PACKAGE_HAS_LIBMALI),y)
RETROLX_EMULATIONSTATION_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-lmali -DCMAKE_SHARED_LINKER_FLAGS=-lmali
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
RETROLX_EMULATIONSTATION_CONF_OPTS += -DGLES2=ON
endif

ifeq ($(BR2_PACKAGE_HAS_LIBEGL),y)
RETROLX_EMULATIONSTATION_CONF_OPTS += -DEGL=ON
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO)$(BR2_PACKAGE_PIPEWIRE),y)
RETROLX_EMULATIONSTATION_CONF_OPTS += -DENABLE_PULSE=ON
else
RETROLX_EMULATIONSTATION_CONF_OPTS += -DENABLE_PULSE=OFF
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
RETROLX_EMULATIONSTATION_CONF_OPTS += -DBCM=ON
endif

ifeq ($(BR2_PACKAGE_KODI),y)
RETROLX_EMULATIONSTATION_CONF_OPTS += -DDISABLE_KODI=0
else
RETROLX_EMULATIONSTATION_CONF_OPTS += -DDISABLE_KODI=1
endif


ifeq ($(BR2_PACKAGE_XORG7),y)
RETROLX_EMULATIONSTATION_CONF_OPTS += -DENABLE_FILEMANAGER=1
else
RETROLX_EMULATIONSTATION_CONF_OPTS += -DENABLE_FILEMANAGER=0
endif

RETROLX_EMULATIONSTATION_KEY_SCREENSCRAPER_DEV_LOGIN=$(shell grep -E '^SCREENSCRAPER_DEV_LOGIN=' $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/emulationstation/retrolx-emulationstation/keys.txt | cut -d = -f 2-)
RETROLX_EMULATIONSTATION_KEY_GAMESDB_APIKEY=$(shell grep -E '^GAMESDB_APIKEY=' $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/emulationstation/retrolx-emulationstation/keys.txt | cut -d = -f 2-)
RETROLX_EMULATIONSTATION_KEY_CHEEVOS_DEV_LOGIN=$(shell grep -E '^CHEEVOS_DEV_LOGIN=' $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/emulationstation/retrolx-emulationstation/keys.txt | cut -d = -f 2-)

ifneq ($(RETROLX_EMULATIONSTATION_KEY_SCREENSCRAPER_DEV_LOGIN),)
RETROLX_EMULATIONSTATION_CONF_OPTS += "-DSCREENSCRAPER_DEV_LOGIN=$(RETROLX_EMULATIONSTATION_KEY_SCREENSCRAPER_DEV_LOGIN)"
endif
ifneq ($(RETROLX_EMULATIONSTATION_KEY_GAMESDB_APIKEY),)
RETROLX_EMULATIONSTATION_CONF_OPTS += "-DGAMESDB_APIKEY=$(RETROLX_EMULATIONSTATION_KEY_GAMESDB_APIKEY)"
endif
ifneq ($(RETROLX_EMULATIONSTATION_KEY_CHEEVOS_DEV_LOGIN),)
RETROLX_EMULATIONSTATION_CONF_OPTS += "-DCHEEVOS_DEV_LOGIN=$(RETROLX_EMULATIONSTATION_KEY_CHEEVOS_DEV_LOGIN)"
endif

define RETROLX_EMULATIONSTATION_RPI_FIXUP
	$(SED) 's|.{CMAKE_FIND_ROOT_PATH}/opt/vc|$(STAGING_DIR)/usr|g' $(@D)/CMakeLists.txt
	$(SED) 's|.{CMAKE_FIND_ROOT_PATH}/usr|$(STAGING_DIR)/usr|g'    $(@D)/CMakeLists.txt
endef

define RETROLX_EMULATIONSTATION_INSTALL_TARGET_CMDS
	echo "EmulationStation built as package, no rootfs install"
endef

define RETROLX_EMULATIONSTATION_MAKEPKG
	$(INSTALL) -m 0755 -d $(RETROLX_EMULATIONSTATION_PKG_DIR)$(RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR)/resources/help
	$(INSTALL) -m 0755 -d $(RETROLX_EMULATIONSTATION_PKG_DIR)$(RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR)/resources/flags
	$(INSTALL) -m 0755 -d $(RETROLX_EMULATIONSTATION_PKG_DIR)$(RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR)/resources/battery
	$(INSTALL) -m 0755 -d $(RETROLX_EMULATIONSTATION_PKG_DIR)$(RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR)/resources/services
	$(INSTALL) -m 0755 -D $(@D)/emulationstation $(RETROLX_EMULATIONSTATION_PKG_DIR)$(RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR)
	"$(TARGET_STRIP)" -s "$(RETROLX_EMULATIONSTATION_PKG_DIR)$(RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR)/emulationstation"
	$(INSTALL) -m 0644 -D $(@D)/resources/*.* $(RETROLX_EMULATIONSTATION_PKG_DIR)$(RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR)/resources
	$(INSTALL) -m 0644 -D $(@D)/resources/help/*.* $(RETROLX_EMULATIONSTATION_PKG_DIR)$(RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR)/resources/help
	$(INSTALL) -m 0644 -D $(@D)/resources/flags/*.* $(RETROLX_EMULATIONSTATION_PKG_DIR)$(RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR)/resources/flags
	$(INSTALL) -m 0644 -D $(@D)/resources/battery/*.* $(RETROLX_EMULATIONSTATION_PKG_DIR)$(RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR)/resources/battery
	$(INSTALL) -m 0644 -D $(@D)/resources/services/*.* $(RETROLX_EMULATIONSTATION_PKG_DIR)$(RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR)/resources/services

	# es_input.cfg
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/datainit/system/configs/emulationstation
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/emulationstation/retrolx-emulationstation/controllers/es_input.cfg \
		$(TARGET_DIR)/usr/share/retrolx/datainit/system/configs/emulationstation

	# Build Pacman package
	cd $(RETROLX_EMULATIONSTATION_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/emulationstation/retrolx-emulationstation/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

### S31emulationstation
# default for most of architectures
RETROLX_EMULATIONSTATION_PREFIX = SDL_NOMOUSE=1
RETROLX_EMULATIONSTATION_CMD = $(RETROLX_EMULATIONSTATION_PKG_INSTALL_DIR)/emulationstation
RETROLX_EMULATIONSTATION_ARGS = --no-splash $${EXTRA_OPTS}
RETROLX_EMULATIONSTATION_POSTFIX = \&
RETROLX_EMULATIONSTATION_CONF_OPTS += -DCEC=OFF

# on rpi1: dont load ES in background
ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI1),y)
RETROLX_EMULATIONSTATION_POSTFIX = \& sleep 5
endif

# on SPLASH_MPV, the splash with video + es splash is ok
ifeq ($(BR2_PACKAGE_RETROLX_SPLASH_MPV),y)
RETROLX_EMULATIONSTATION_ARGS = $${EXTRA_OPTS}
endif

# es splash is ok when there is no video
ifeq ($(BR2_PACKAGE_RETROLX_SPLASH_IMAGE)$(BR2_PACKAGE_RETROLX_SPLASH_ROTATE_IMAGE),y)
RETROLX_EMULATIONSTATION_ARGS = $${EXTRA_OPTS}
endif

# # on x86/x86_64: startx runs ES
ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER),y)
RETROLX_EMULATIONSTATION_PREFIX =
RETROLX_EMULATIONSTATION_CMD = startx
RETROLX_EMULATIONSTATION_ARGS =
endif

define RETROLX_EMULATIONSTATION_BOOT
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/emulationstation/retrolx-emulationstation/S31emulationstation $(TARGET_DIR)/etc/init.d/S31emulationstation
	sed -i -e 's;%RETROLX_EMULATIONSTATION_PREFIX%;${RETROLX_EMULATIONSTATION_PREFIX};g' \
		-e 's;%RETROLX_EMULATIONSTATION_CMD%;${RETROLX_EMULATIONSTATION_CMD};g' \
		-e 's;%RETROLX_EMULATIONSTATION_ARGS%;${RETROLX_EMULATIONSTATION_ARGS};g' \
		-e 's;%RETROLX_EMULATIONSTATION_POSTFIX%;${RETROLX_EMULATIONSTATION_POSTFIX};g' \
		$(TARGET_DIR)/etc/init.d/S31emulationstation
endef

RETROLX_EMULATIONSTATION_PRE_CONFIGURE_HOOKS += RETROLX_EMULATIONSTATION_RPI_FIXUP
RETROLX_EMULATIONSTATION_POST_INSTALL_TARGET_HOOKS += RETROLX_EMULATIONSTATION_BOOT
RETROLX_EMULATIONSTATION_POST_INSTALL_TARGET_HOOKS += RETROLX_EMULATIONSTATION_MAKEPKG
$(eval $(cmake-package))
