################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_SUN50I_VERSION = 5.15.61-1
RETROLX_KERNEL_SUN50I_ARCH = sun50i
RETROLX_KERNEL_SUN50I_SOURCE = kernel-$(RETROLX_KERNEL_SUN50I_ARCH)-$(RETROLX_KERNEL_SUN50I_VERSION).tar.gz
RETROLX_KERNEL_SUN50I_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_SUN50I_ARCH)/$(RETROLX_KERNEL_SUN50I_VERSION)

define RETROLX_KERNEL_SUN50I_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/kernel-sun50i
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_SUN50I_DL_SUBDIR)/$(RETROLX_KERNEL_SUN50I_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/kernel-sun50i/
endef

$(eval $(generic-package))
