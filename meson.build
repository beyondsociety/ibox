# Specify the project
project('ibox', 'c',
	version : '0.0.1',
	license : 'BSD 3-Clause',
	meson_version : '>=0.49.0',
	default_options : ['buildtype=plain', 'c_std=c99'])

subdir('include')
subdir('src')

# Script that runs the ISO Image with qemu
run_target('qemu', command : 'scripts/qemu-meson-wrapper.sh')
run_target('bochs', command : 'scripts/bochs-meson-wrapper.sh')
