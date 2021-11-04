################################################################################
#
# mupen64plus video video-glide64mk2
#
################################################################################
# Version.: Commits on Sep 14, 2021
MUPEN64PLUS_VIDEO_GLIDE64MK2_VERSION = 5ac60b38e2c9d9dea3c21fd341b03799841b0b5f
MUPEN64PLUS_VIDEO_GLIDE64MK2_SITE = $(call github,mupen64plus,mupen64plus-video-glide64mk2,$(MUPEN64PLUS_VIDEO_GLIDE64MK2_VERSION))
MUPEN64PLUS_VIDEO_GLIDE64MK2_LICENSE = GPLv2
MUPEN64PLUS_VIDEO_GLIDE64MK2_DEPENDENCIES = sdl2 alsa-lib mupen64plus-core boost
MUPEN64PLUS_VIDEO_GLIDE64MK2_INSTALL_STAGING = YES

ifeq ($(BR2_i686)$(BR2_x86_64),)
	MUPEN64PLUS_VIDEO_GLIDE64MK2_TARGET_CXX_FLAGS = -DNO_ASM
endif

define MUPEN64PLUS_VIDEO_GLIDE64MK2_BUILD_CMDS
    $(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
		PREFIX="$(STAGING_DIR)/usr" \
		PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
		HOST_CPU="$(MUPEN64PLUS_HOST_CPU)" \
        APIDIR="$(STAGING_DIR)/usr/include/mupen64plus" \
		GL_CFLAGS="$(MUPEN64PLUS_GL_CFLAGS)" \
		GL_LDLIBS="$(MUPEN64PLUS_GL_LDLIBS)" \
        -C $(@D)/projects/unix all $(MUPEN64PLUS_PARAMS) OPTFLAGS="$(MUPEN64PLUS_VIDEO_GLIDE64MK2_TARGET_CXX_FLAGS)"
endef

define MUPEN64PLUS_VIDEO_GLIDE64MK2_INSTALL_TARGET_CMDS
    $(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
		PREFIX="$(TARGET_DIR)/usr/" \
		PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
		HOST_CPU="$(MUPEN64PLUS_HOST_CPU)" \
        APIDIR="$(STAGING_DIR)/usr/include/mupen64plus" \
		GL_CFLAGS="$(MUPEN64PLUS_GL_CFLAGS)" \
		GL_LDLIBS="$(MUPEN64PLUS_GL_LDLIBS)" \
		INSTALL="/usr/bin/install" \
		INSTALL_STRIP_FLAG="" \
		-C $(@D)/projects/unix all $(MUPEN64PLUS_PARAMS) OPTFLAGS="$(MUPEN64PLUS_VIDEO_GLIDE64MK2_TARGET_CXX_FLAGS)" install
endef

define MUPEN64PLUS_VIDEO_GLIDE64MK2_CROSS_FIXUP
    $(SED) 's|/opt/vc/include|$(STAGING_DIR)/usr/include|g' $(@D)/projects/unix/Makefile
    $(SED) 's|/opt/vc/lib|$(STAGING_DIR)/usr/lib|g' $(@D)/projects/unix/Makefile
endef

MUPEN64PLUS_VIDEO_GLIDE64MK2_PRE_CONFIGURE_HOOKS += MUPEN64PLUS_VIDEO_GLIDE64MK2_CROSS_FIXUP

$(eval $(generic-package))
