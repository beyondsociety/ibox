# Find Nasm
nasm = find_program('nasm', required: true)

# Generator that will take object files
asm_gen = generator(nasm,
        output : '@BASENAME@.o',
        arguments : ['-f', 'elf32', '@INPUT@', '-o', '@OUTPUT@'])

# Generators take in an array of files to generate
asm_sources = asm_gen.process(['stub.s'])

kernel_sources = files(['bga.c', 'kernel.c', 'io.c', 'multiboot.c', 'stdio.c', 'string.c', 'terminal.c', 'vsprintf.c']) 

if meson.get_compiler('c').get_id() == 'clang'
	c_args = ['-m32', '-c', '-ffreestanding', '-Wall', '-Wextra']
	link_args = ['-nostdlib', '-Wl,-T,../src/linker.ld', '-Wl,-m,elf_i386', '-Wl,-Map,info.map', '-Wl,-L,libgcc']
else
	c_args = ['-c', '-ffreestanding', '-Wall', '-Wextra']
        link_args = ['-nostdlib', '-T', '../src/linker.ld', '-Wl,-Map,info.map', '-lgcc']
endif

linker_file = files('linker.ld')
image = executable('kernel.elf', asm_sources, kernel_sources,
        c_args : c_args,
        link_args : link_args,
	link_depends : 'linker.ld',
        include_directories : inc)
