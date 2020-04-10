# Finds subdirectory for asm files depending on architecture
arch_path = 'arch/@0@/'.format(host_machine.cpu_family())

# Sub directory for arch specific files
subdir(arch_path)

arch_linker_file = meson.current_source_dir() + '/' + arch_path + 'linker.ld'

# Kernel sources
kernel_srcs = files(
	'bga.c', 'kernel.c',
	'io.c', 'multiboot.c',
	'stdio.c', 'string.c',
	'terminal.c', 'vsprintf.c')

# Compiler options based on type of compiler used
compiler = meson.get_compiler('c')

if compiler.get_id() == 'clang'
	  c_args = ['-m32', '-c', '-ffreestanding', '-Wall', '-Wextra']
	  link_args = ['-nostdlib', '-Wl,-T', arch_linker_file, '-Wl,-m,elf_i386', '-Wl,-Map=info.map', '-Wl,-L,libgcc']
else
	compiler.get_id() == 'gcc'
		c_args = ['-c', '-ffreestanding', '-Wall', '-Wextra']
		link_args = ['-nostdlib', '-T', arch_linker_file, '-Wl,-Map=info.map', '-lgcc']
endif

# Include directory
inc_dirs = include_directories('include')

# Executable
image = executable(
	'kernel.elf',
	asm_srcs, kernel_srcs,
        c_args : c_args,
        link_args : link_args,
        include_directories : inc_dirs)
