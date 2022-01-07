################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_H616_VERSION = 5.15.13
RETROLX_KERNEL_H616_ARCH = h616
RETROLX_KERNEL_H616_SOURCE = kernel-$(RETROLX_KERNEL_H616_ARCH)-$(RETROLX_KERNEL_H616_VERSION).tar.gz
RETROLX_KERNEL_H616_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_H616_ARCH)/$(RETROLX_KERNEL_H616_VERSION)

define RETROLX_KERNEL_H616_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/kernel-h616
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_H616_DL_SUBDIR)/$(RETROLX_KERNEL_H616_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/kernel-h616/
endef

$(eval $(generic-package))
