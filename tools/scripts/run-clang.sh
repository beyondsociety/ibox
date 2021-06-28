#!bin/bash

GREEN_TEXT='\033[1;32m'  # Bold Green
NORMAL='\033[0;m'        # No Color

echo "${GREEN_TEXT}Removing build directory for new build... ${NORMAL}"
rm -rfv ./clang-build

echo ''
echo "${GREEN_TEXT}Building Ibox... ${NORMAL}"
meson clang-build --cross-file clang.build
ninja --verbose -C clang-build

echo ''
echo "${GREEN_TEXT}Building ISO Image... ${NORMAL}"
cp ./clang-build/kernel.elf ./iso/boot/
#mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
#-boot-info-table -input-charset utf8 -o ./clang-build/boot.iso iso
grub-mkrescue -o ./clang-build/boot.iso iso
