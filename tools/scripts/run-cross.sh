#!bin/bash
# Todo: add 32/64 bit detection to build script

TARGET32="i686-elf-gcc"       # Target 32-bit arch of build
TARGET64="x86_64-elf-gcc"     # Target 64-bit arch of build

PREFIX32="/usr/local/cross32" # Location of 32-bit cross-compiler directory
PREFIX64="/usr/local/cross64" # Location of 64-bit cross-compiler directory

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
  #export PATH="$PREFIX64/bin:$PATH"
else
  echo "Need cross-compiler to build Ibox... "
  exit 1
fi

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
cp ./cross-build/kernel.elf ./iso/boot/
mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
-boot-info-table -input-charset utf8 -o ./cross-build/boot.iso iso
#grub-mkrescue -o ./clang-build/boot.iso iso
