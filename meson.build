# Specify the project
project('ibox', 'c',
	version : '0.0.1',
	license : 'BSD 3-Clause',
	meson_version : '>=0.50.0',

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
image = executable(
	'kernel.elf',
	asm_srcs, kernel_srcs,
	c_args : c_args,
	link_args : link_args,
	include_directories : inc_dirs,
	implicit_include_directories : false)
