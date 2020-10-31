#!bin/bash

GREEN_TEXT='\033[1;32m'   # Bold Green
NORMAL='\033[0;m'         # No color

<<<<<<< HEAD
TARGET="i686-elf-gcc"
PREFIX="/usr/local/cross"
#if ( find / -iname $TARGET -print -quit 2>/dev/null ); then
#  echo "${GREEN_TEXT}Found cross-compiler: ${NORMAL}$TARGET"
#else
#  echo "Need cross-compiler to build Ibox... "
#  exit 1
#fi

if [ ! -f "$PREFIX" ]; then
  echo "${GREEN_TEXT}Found cross-compiler...${NORMAL}"
  echo "$PREFIX"
=======
TARGET="i686-elf-gcc"     # Target arch of build
PREFIX="/usr/local/cross" # Location of cross-compiler dir

if ( find / -type f -iname $TARGET -print -quit 2>/dev/null ); then
  echo "${GREEN_TEXT}Found cross-compiler: ${NORMAL}$TARGET"
>>>>>>> bb44f9c5ab276cdb10c058b71fa5f1a5bda128bb
  export PATH="$PREFIX/bin:$PATH"
else
  echo "Need cross-compiler to build Ibox... "
  exit 1
fi

echo ''
echo "${GREEN_TEXT}Removing build directiory for new build...${NORMAL}"
rm -rfv ./cross-build

echo ''
echo "${GREEN_TEXT}Building Ibox...${NORMAL}"
#export PATH="~/.local/bin:$PATH" # Path to meson
~/meson/meson.py cross-build --cross-file cross-compiler.build
ninja --verbose -C cross-build

echo ''
echo "${GREEN_TEXT}Building ISO Image...${NORMAL}"
cp ./cross-build/kernel.elf ./iso/boot/
mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
-boot-info-table -input-charset utf8 -o ./cross-build/boot.iso iso
