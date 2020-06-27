# Specify the project
project('ibox', 'c',
	version : '0.0.1',
	license : 'BSD 3-Clause',
	meson_version : '>=0.50.0',
	default_options : ['b_asneeded=false', 'b_lundef=false', 'buildtype=plain', 'c_std=c99'])

# Directory for kernel sources
subdir('kernel')

# Script that runs the ISO Image with qemu and bochs
run_target('qemu', command : 'tools/scripts/qemu-meson-wrapper.sh')
run_target('bochs', command : 'tools/scripts/bochs-meson-wrapper.sh')
