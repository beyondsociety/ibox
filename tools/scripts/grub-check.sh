# Todo: Add code to detect both multiboot versions
if grub-file --is-x86-multiboot ${PWD}/cross-build/kernel.elf; then
# if grub-file --is-x86-multiboot ${PWD}/cross-build/kernel.elf; then
# 	echo multiboot confirmed
# elif grub-file --is-x86-multiboot ${PWD}/clang-build/kernel.elf; then
#   echo multiboot confirmed

if grub-file --is-x86-multiboot ./clang-build/kernel.elf; then
	echo multiboot confirmed
elif grub-file --is-x86-multiboot2 ${PWD}/cross-build/kernel.elf; then
  echo multiboot confirmed2
else
	echo file is not multiboot
fi
