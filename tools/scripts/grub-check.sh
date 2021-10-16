if grub-file --is-x86-multiboot ./cross-build/kernel/kernel.elf; then
	echo multiboot confirmed
elif grub-file --is-x86-multiboot ./clang-build/kernel/kernel.elf; then
  echo multiboot confirmed
else
	echo file is not multiboot
fi
