#!/usr/bin/env bash

GREEN_TEXT='\033[1;32m'       # Bold Green
YELLOW_TEXT='\033[1;33m'      # Bold Yellow
NORMAL='\033[0;m'             # No Color

read -p "$(echo -e ${YELLOW_TEXT}"Please specify a build-arch so we can build Ibox ${GREEN_TEXT}(x86 or x86-64)${YELLOW_TEXT}:") ${NORMAL}" ARCH

echo ''
echo -e "${GREEN_TEXT}Removing build directory for new build... ${NORMAL}"
rm -rfv ./clang-build

echo ''
echo -e "${YELLOW_TEXT}Building Ibox... ${NORMAL}"
if [ "$ARCH" = "x86" ]; then
  # 32-bit stuff here
  meson setup clang-build --cross-file cross-files/clang32.ini
  ninja --verbose -C clang-build
elif [ "$ARCH" = "x86-64" ]; then
  # 64-bit stuff here
  meson setup clang-build --cross-file cross-files/clang64.ini
  ninja --verbose -C clang-build
else
  echo -e "${YELLOW_TEXT}No build-arch found, halting... "
  exit 1
fi

echo ''
echo -e "${GREEN_TEXT}Building ISO Image... ${NORMAL}"
cp ./clang-build/kernel.elf ./iso/boot/

# Need to use grub-mkrescume to create iso instead of mkisofs until I recompile grub from source
#mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
#-boot-info-table -input-charset utf8 -o ./clang-build/boot.iso iso
grub-mkrescue -o ./clang-build/boot.iso iso
