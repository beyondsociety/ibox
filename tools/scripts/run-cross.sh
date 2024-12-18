#!/usr/bin/env bash

GREEN_TEXT='\033[1;32m'       # Bold Green
YELLOW_TEXT='\033[1;33m'      # Bold Yellow
NORMAL='\033[0;m'             # No Color

TARGET32="i686-elf-gcc"       # Target 32-bit arch of build
TARGET64="x86_64-elf-gcc"     # Target 64-bit arch of build

PREFIX32="/usr/local/cross32" # Location of 32-bit cross-compiler directory
PREFIX64="/usr/local/cross64" # Location of 64-bit cross-compiler directory

read -p "$(echo -e ${GREEN_TEXT}"Please specify a build-arch so we can build Ibox${YELLOW_TEXT} (x86 or x86-64):${GREEN_TEXT}" ${NORMAL})" ARCH          
if [ "$ARCH" = "x86" ]; then
  # 32-bit stuff here
  echo -e "${YELLOW_TEXT}Found cross-compiler: ${NORMAL}\c"
  find /usr -name $TARGET32 -print -quit 2>/dev/null
  export PATH="$PREFIX32/bin:$PATH"
elif [ "$ARCH" = "x86-64" ]; then
  # 64-bit stuff here
  echo -e "${YELLOW_TEXT}Found cross-compiler: ${NORMAL}\c"
  find /usr -type f -name $TARGET32 -print -quit 2>/dev/null
  export PATH="$PREFIX32/bin:$PATH"
else
  echo -e "${YELLOW_TEXT}No compiler found, halting... ${NORMAL}"
  exit 1
fi

echo ''
echo -e "${GREEN_TEXT}Removing build directiory for new build...${NORMAL}"
rm -rfv ./cross-build

echo ''
echo -e "${YELLOW_TEXT}Building Ibox... ${NORMAL}"
if [ "$ARCH" = "x86" ]; then
  # 32-bit stuff here
  meson setup cross-build --cross-file cross-files/cross32.ini
  ninja --verbose -C cross-build
elif [ "$ARCH" = "x86-64" ]; then
  # 64-bit stuff here
  meson setup cross-build --cross-file cross-files/cross64.ini
  ninja --verbose -C cross-build
else
  echo -e "${GREEN_TEXT}No build-arch found, halting... ${NORMAL}"
  exit 1
fi

echo ''
echo -e "${GREEN_TEXT}Building ISO Image... ${NORMAL}"
cp ./cross-build/kernel.elf ./iso/boot/

# Need to use grub-mkrescume to create iso instead of mkisofs until I recompile grub from source
#mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
#-boot-info-table -input-charset utf8 -o ./cross-build/boot.iso iso
grub-mkrescue -o ./cross-build/boot.iso iso
