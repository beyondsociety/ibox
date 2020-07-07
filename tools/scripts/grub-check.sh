if grub-file --is-x86-multiboot ./build/kernel.elf; then
	echo multiboot confirmed
else
	echo file is not multiboot
fi
