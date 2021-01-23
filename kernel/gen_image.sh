cp ./cross-build/kernel.elf ./iso/boot/
#mkisofs -R -b boot/grub/eltorito.img -no-emul-boot -boot-load-size 4 \
#-boot-info-table -input-charset utf8 -o ./cross-build/boot.iso iso

grub-mkrescue -o ./cross-build/boot.iso iso
