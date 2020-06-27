#!bin/bash

GREEN_TEXT='\033[1;32m'  # Bold Green
NORMAL='\033[0;m'        # No color

echo "${GREEN_TEXT}Found cross-compiler...${NORMAL}"
PREFIX="/usr/local/cross"
if [ "$PREFIX/bin" ] ; then
    PATH="$PREFIX/bin:$PATH"
fi
#export PATH="/usr/local/cross/bin:$PATH" # Path to cross-compiler
echo /usr/local/cross/bin

echo ''
echo "${GREEN_TEXT}Removing build directiory for new build...${NORMAL}"
rm -rfv ./cross-build

echo ''
echo "${GREEN_TEXT}Building Ibox...${NORMAL}"
export PATH="~/.local/bin:$PATH" # Path to meson
meson cross-build --cross-file cross-compiler.build
ninja -C cross-build

echo ''
echo "${GREEN_TEXT}Building ISO Image...${NORMAL}"
cp ./cross-build/kernel/kernel.elf ./iso/boot/
mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
-boot-info-table -input-charset utf8 -o ./cross-build/boot.iso iso
