# Specify the project
project('ibox', 'c',
	version : '0.0.1',
	license : 'BSD 3-Clause',
	meson_version : '>=0.55.0',

	default_options : [
		'b_asneeded=false',
		'b_lundef=false',
		'buildtype=plain',
		'c_std=gnu99'])

# Directory for kernel files
subdir('kernel')

# Directory for firmware (pc-bios and uefi files)
subdir('firmware/pc-bios')

# Script that runs the ISO Image with qemu and bochs
run_target('qemu', command : 'tools/scripts/qemu-meson-wrapper.sh')
run_target('bochs', command : 'tools/scripts/bochs-meson-wrapper.sh')

# Include directory
inc_dirs = include_directories('kernel/include')

# Executable
kernel = executable(
	'kernel.elf',
	asm_srcs, kernel_srcs,
	c_args : c_args,
	link_args : link_args,
	include_directories : inc_dirs,
	implicit_include_directories : false,
	native : false)

#gen_image = find_program(meson.current_source_dir() / 'kernel/gen_image.sh', required: false)
#mkrescue = find_program('grub-mkrescue', required: false)

# image
#image = custom_target(
#	'ibox.iso',
#	build_by_default : true,
#	command : [files(meson.current_source_dir() / 'kernel/gen_image.sh'), meson.current_source_dir() / 'iso/grub/grub.cfg', kernel, mkrescue],
#	output : 'ibox.iso'
#)
