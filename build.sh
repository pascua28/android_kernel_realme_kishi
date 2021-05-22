#!/bin/bash

CLANG_DIR=~/clang/bin/clang

if [ ! -f out/.config ]; then
	make ARCH=arm64 O=out kishi_defconfig
else
	make ARCH=arm64 O=out oldconfig
fi

export KBUILD_COMPILER_STRING=$($CLANG_DIR --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')

make -j8 ARCH=arm64 O=out \
	CC=$CLANG_DIR CLANG_TRIPLE=aarch64-linux-gnu- \
	CROSS_COMPILE=~/gcc-7.4.1/bin/aarch64-linux-gnu- \
	Image.gz-dtb

IMAGE="out/arch/arm64/boot/Image.gz-dtb"

if [[ -f "$IMAGE" ]]; then
	rm AnyKernel3/Image.gz-dtb > /dev/null 2>&1
	rm AnyKernel3/*.zip > /dev/null 2>&1
	cp $IMAGE AnyKernel3/Image.gz-dtb
	cd AnyKernel3
	zip -r release.zip .
fi
