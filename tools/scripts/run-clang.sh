#!bin/bash

GREEN_TEXT='\033[1;32m'       # Bold Green
YELLOW_TEXT='\033[1;33m'      # Bold Yellow
NORMAL='\033[0;m'             # No Color

read -p "$(echo ${YELLOW_TEXT}"Please specify a build-arch so we can build Ibox (x86 or x86-64): "${NORMAL})" ARCH

echo ''
echo "${GREEN_TEXT}Removing build directory for new build... ${NORMAL}"
rm -rfv ./clang-build

echo ''
echo "${GREEN_TEXT}Building Ibox... ${NORMAL}"
if [ "$ARCH" = "x86" ]; then
  # 32-bit stuff here
  meson clang-build --cross-file cross-files/clang32.ini
  ninja --verbose -C clang-build
else if [ "$ARCH" = "x86-64" ]; then
  # 64-bit stuff here
  meson clang-build --cross-file cross-files/clang64.ini
  ninja --verbose -C clang-build
else
  echo "No build-arch found, halting... "
  exit 1
 fi
fi

echo ''
echo "${GREEN_TEXT}Building ISO Image... ${NORMAL}"
cp ./clang-build/kernel.elf ./iso/boot/

# Need to use grub-mkrescume to create iso instead of mkisofs until I recompile grub from source
#mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
#-boot-info-table -input-charset utf8 -o ./clang-build/boot.iso iso
grub-mkrescue -o ./clang-build/boot.iso iso
