# Todo: Add code to detect both multiboot versions
if grub-file --is-x86-multiboot ./clang-build/kernel.elf; then
	echo multiboot confirmed
elif grub-file --is-x86-multiboot2 ./clang-build/kernel.elf; then
  echo multiboot confirmed2
else
	echo file is not multiboot
fi
