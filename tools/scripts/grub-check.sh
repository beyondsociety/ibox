if grub-file --is-x86-multiboot ${PWD}/cross-build/kernel.elf; then
	echo multiboot confirmed
elif grub-file --is-x86-multiboot ${PWD}/clang-build/kernel.elf; then
  echo multiboot confirmed
else
	echo file is not multiboot
fi
