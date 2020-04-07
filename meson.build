# Specify the project
project('ibox', 'c',
	version : '0.0.1',
	license : 'BSD 3-Clause',
	meson_version : '>=0.50.0',
	default_options : meson.get_cross_property('project_configuration'))
	#default_options : ['b_as_needed=false','b_no_undefined=false','buildtype=plain','c_std=c99'])
	#default_options : ['b_as_needed=false'])

# Directory for kernel sources
subdir('src')

# Script that runs the ISO Image with qemu and bochs
#run_target('qemu', command : 'scripts/qemu-meson-wrapper.sh')
#run_target('bochs', command : 'scripts/bochs-meson-wrapper.sh')
