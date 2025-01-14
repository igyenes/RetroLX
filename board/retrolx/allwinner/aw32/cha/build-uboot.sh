#!/bin/bash

HOST_DIR=$1
IMAGES_DIR=$2

# Clone U-Boot mainline
[ ! -f "u-boot-2022.07.tar.bz2" ] && wget "https://ftp.denx.de/pub/u-boot/u-boot-2022.07.tar.bz2"
tar xf u-boot-2022.07.tar.bz2
cd u-boot-2022.07

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Make clean
make clean

# Make config
make libretech_all_h3_cc_h3_defconfig

# Build it
ARCH=arm CROSS_COMPILE="${HOST_DIR}/bin/arm-buildroot-linux-gnueabihf-" make -j$(nproc)
mkdir -p ../../uboot-cha

# Copy to appropriate place
cp u-boot-sunxi-with-spl.bin ../../uboot-cha/
