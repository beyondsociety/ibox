#!bin/bash
Yellow='\033[1;33m'
Normal='\033[0;m'

echo "${Yellow}Found cross-compiler...${Normal}"
export PATH="/usr/local/cross/bin:$PATH"

echo "${Yellow}Removing build directiory for new build...${Normal}"
rm -rf ./build

echo ''
echo "${Yellow}Building Ibox...${Normal}"
~/meson/meson.py build --cross-file cross-compiler.build
ninja -C build

echo ''
echo "${Yellow}Building ISO Image...${Normal}"
cp ./build/src/kernel.elf ./iso/boot/
mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
-boot-info-table -input-charset utf8 -o boot.iso iso

echo ''
echo "${Yellow}Runing ISO image...${Normal}"
ninja -C build qemu
