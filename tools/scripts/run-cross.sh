#!/bin/bash
GREEN_TEXT='\033[1;32m'       # Bold Green
YELLOW_TEXT='\033[1;33m'      # Bold Yellow
NORMAL='\033[0;m'             # No Color

TARGET32="i686-elf-gcc"       # Target arch of build
PREFIX32="/usr/local/cross32" # Location of cross-compiler dir

TARGET64="x86_64-elf-gcc"       # Target arch of build
PREFIX64="/usr/local/cross64" # Location of cross-compiler dir

read -p "$(echo $YELLOW_TEXT"Please specify a build-arch so we can build Ibox (x86 or x86-64): "$NORMAL)" ARCH
if [ "$ARCH" = "x86" ]; then
  # 32-bit stuff here
  echo "${GREEN_TEXT}Found cross-compiler: ${NORMAL}\c"
  find /usr -name $TARGET32 -print -quit 2>/dev/null
  #export PATH="$PREFIX32/bin:$PATH"
else if [ "$ARCH" = "x86-64" ]; then
  # 64-bit stuff here
  echo "${GREEN_TEXT}Found cross-compiler: ${NORMAL}\c"
  find /usr -name $TARGET64 -print -quit 2>/dev/null
  export PATH="$PREFIX64/bin:$PATH"
else
  echo "Need cross-compiler to build Ibox... "
  exit 1
 fi
fi

sleep 3 && echo ''
echo "${GREEN_TEXT}Removing build directory for new build... ${NORMAL}"
rm -rfv ./cross-build

echo ''
echo "${GREEN_TEXT}Building Ibox... ${NORMAL}"
if [ "$ARCH" = "x86" ]; then
  # 32-bit stuff here
  meson cross-build --cross-file cross-files/cross32.ini
  ninja --verbose -C cross-build
else [ "$ARCH" = "x86-64" ]
  # 64-bit stuff here
  meson cross-build --cross-file cross-files/cross64.ini
  ninja --verbose -C cross-build
fi

echo ''
echo "${GREEN_TEXT}Building ISO Image... ${NORMAL}"
cp ./cross-build/kernel.elf ./iso/boot/
#mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
#-boot-info-table -input-charset utf8 -o ./clang-build/boot.iso iso
grub-mkrescue -o ./cross-build/boot.iso iso
