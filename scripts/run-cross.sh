#!bin/bash
Yellow='\033[1;33m'
Normal='\033[0;m'

echo ''
echo "${Yellow}Found cross-compiler...${Normal}"
export PATH="/usr/local/cross/bin:$PATH"
echo /usr/local/cross/bin

echo ''
echo "${Yellow}Removing build directiory for new build...${Normal}"
rm -rfv ./cross-build

echo ''
echo "${Yellow}Building Ibox...${Normal}"
#~/meson/meson.py cross-build --cross-file cross-compiler.build
~/.local/bin/meson cross-build --cross-file cross-compiler.build
ninja -C cross-build

echo ''
echo "${Yellow}Building ISO Image...${Normal}"
cp ./cross-build/src/kernel.elf ./iso/boot/
mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
-boot-info-table -input-charset utf8 -o boot.iso iso

#echo ''
#echo "${Yellow}Runing ISO image...${Normal}"
#ninja -C cross-build qemu
#ninja -C cross-build bochs
