#!/bin/bash

# HOST_DIR = host dir
# BOARD_DIR = board specific dir
# BUILD_DIR = base dir/build
# BINARIES_DIR = images dir
# TARGET_DIR = target dir
# RETROLX_BINARIES_DIR = RetroLX binaries sub directory

HOST_DIR=$1
BOARD_DIR=$2
BUILD_DIR=$3
BINARIES_DIR=$4
TARGET_DIR=$5
RETROLX_BINARIES_DIR=$6

mkdir -p "${RETROLX_BINARIES_DIR}/boot/packages" || exit 1
cat "${BUILD_DIR}/board/retrolx/packages.txt" "${BUILD_DIR}/board/retrolx/rockchip/rk3288/packages.txt" > "${RETROLX_BINARIES_DIR}/boot/packages.txt"
cat "${RETROLX_BINARIES_DIR}/boot/packages.txt" | while read line; do cp "${BUILD_DIR}/repo/${line}"* "${RETROLX_BINARIES_DIR}/boot/packages/"; done

mkdir -p "${RETROLX_BINARIES_DIR}/uboot" || exit 1
cp "${BOARD_DIR}/build-uboot.sh"          "${RETROLX_BINARIES_DIR}/uboot/" || exit 1
cd "${RETROLX_BINARIES_DIR}/uboot/" && ./build-uboot.sh "${HOST_DIR}" "${BINARIES_DIR}" || exit 1

mkdir -p "${RETROLX_BINARIES_DIR}/boot/boot"     || exit 1
mkdir -p "${RETROLX_BINARIES_DIR}/boot/extlinux" || exit 1

cp "${BINARIES_DIR}/zImage"          "${RETROLX_BINARIES_DIR}/boot/boot/linux"           || exit 1
cp "${BINARIES_DIR}/initrd.gz"       "${RETROLX_BINARIES_DIR}/boot/boot/"                || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs" "${RETROLX_BINARIES_DIR}/boot/boot/retrolx.update" || exit 1
cp "${BINARIES_DIR}/modules"         "${RETROLX_BINARIES_DIR}/boot/boot/modules"         || exit 1

cp "${BINARIES_DIR}/rk3288-miqi.dtb" "${RETROLX_BINARIES_DIR}/boot/boot/"     || exit 1
cp "${BOARD_DIR}/boot/extlinux.conf" "${RETROLX_BINARIES_DIR}/boot/extlinux/" || exit 1

exit 0
