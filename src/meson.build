# Sub directory for asm files
subdir('arch/x86')

kernel_sources = files(['bga.c', 'kernel.c', 'io.c', 'multiboot.c', 'stdio.c', 'string.c', 'terminal.c', 'vsprintf.c']) 

if meson.get_compiler('c').get_id() == 'clang'
	c_args = ['-m32', '-c', '-ffreestanding', '-Wall', '-Wextra']
	link_args = ['-nostdlib', '-Wl,-T,../src/linker.ld', '-Wl,-m,elf_i386', '-Wl,-Map,info.map', '-Wl,-L,libgcc']
else
	c_args = ['-c', '-ffreestanding', '-Wall', '-Wextra']
        link_args = ['-nostdlib', '-T', '../src/linker.ld', '-Wl,-Map,info.map', '-lgcc']
endif

inc_dirs = include_directories('../include')

linker_file = files('linker.ld')
image = executable('kernel.elf', asm_sources, kernel_sources,
        c_args : c_args,
        link_args : link_args,
	link_depends : 'linker.ld',
        include_directories : inc_dirs)
