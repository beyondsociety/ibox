# Location of linker file (Todo: fix hardcoded path)
linker_file = meson.source_root() + '/firmware/pc-bios/linker.ld'

# Kernel sources
kernel_srcs = files(
	'bga.c', 'kernel.c',
	'io.c', 'lfbvideo.c',
	'multiboot.c', 'serial.c',
	'stdio.c', 'string.c',
	'terminal.c', 'vsprintf.c')

# Pass compiler and linker args from cross-file to ibox
if meson.is_cross_build()
	c_args = meson.get_external_property('c_args', 'native: false')
  link_args = meson.get_external_property('c_link_args', 'native: false')
endif

# Find the compiler program Clang
find_program('clang', required: true)

# Compiler options based on type of compiler used
compiler = meson.get_compiler('c')
	if compiler.get_id() == 'clang'
		c_args = ['-Wall', '-Wextra']
	 	link_args = ['-Wl,-T', linker_file, '-Wl,-Map=info.map', '-Wl,-L,libgcc']
	elif compiler.get_id() == 'gcc'
		c_args = ['-Wall', '-Wextra']
		link_args = ['-T', linker_file, '-Wl,-Map=info.map', '-lgcc']
endif
