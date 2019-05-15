#!bin/bash
Yellow='\033[1;33m'
Normal='\033[0;m'

echo "${Yellow}Removing build directory for new build...${Normal}"
rm -rf ./clang-build

echo ''
echo "${Yellow}Building Ibox...${Normal}"
~/meson/meson.py clang-build --native-file clang.build
ninja -C clang-build

echo ''
echo "${Yellow}Building ISO Image...${Normal}"
cp ./clang-build/src/kernel.elf ./iso/boot/
mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
-boot-info-table -input-charset utf8 -o boot.iso iso

#echo ''
#echo "${Yellow}Runing ISO Image...${Normal}"
#ninja -C clang-build qemu
