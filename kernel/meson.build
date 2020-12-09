# Location of linker file (Todo: fix hardcoded path)
linker_file = meson.source_root() + '/firmware/pc-bios/linker.ld'

# Kernel sources
kernel_srcs = files(
	'bga.c', 'kernel.c',
	'io.c', 'lfbvideo.c',
	'multiboot.c', 'serial.c',
	'stdio.c', 'string.c',
	'terminal.c', 'vsprintf.c')

if meson.is_cross_build()
	c_args = meson.get_cross_property('c_args')
	link_args = meson.get_cross_property('c_link_args')
endif

# Compiler options based on type of compiler used
compiler = meson.get_compiler('c')
if compiler.get_id() == 'clang'
	c_args = ['--target=i386-none-elf', '-Wall', '-Wextra']
  link_args = ['-Wl,-T', linker_file, '--target=i386-linux-elf', '-Wl,-Map=info.map', '-Wl,-L,libgcc']
else
	compiler.get_id() == 'gcc'
	c_args = ['-Wall', '-Wextra']
	link_args = ['-T', linker_file, '-Wl,-Map=info.map', '-lgcc']
endif
