################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_AW32_VERSION = 5.15.61-1
RETROLX_KERNEL_AW32_ARCH = aw32
RETROLX_KERNEL_AW32_SOURCE = kernel-$(RETROLX_KERNEL_AW32_ARCH)-$(RETROLX_KERNEL_AW32_VERSION).tar.gz
RETROLX_KERNEL_AW32_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_AW32_ARCH)/$(RETROLX_KERNEL_AW32_VERSION)

define RETROLX_KERNEL_AW32_INSTALL_TARGET_CMDS
        mkdir -p $(BINARIES_DIR)/kernel-aw32
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_AW32_DL_SUBDIR)/$(RETROLX_KERNEL_AW32_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/kernel-aw32/
endef

$(eval $(generic-package))
