# Finds subdirectory for asm files depending on architecture
arch_path = 'arch/@0@/'.format(host_machine.cpu_family())

# Sub directory for arch specific files
subdir(arch_path)

arch_linker_file = meson.current_source_dir() + '/' + arch_path + 'linker.ld'

# Kernel sources
kernel_srcs = files('kernel.c',)

if meson.is_cross_build()
	c_args = meson.get_cross_property('c_args')
	link_args = meson.get_cross_property('c_link_args')
endif

# Compiler options based on type of compiler used
compiler = meson.get_compiler('c')
if compiler.get_id() == 'clang'
  c_args = ['-Wall', '-Wextra']
	link_args = ['-Wl,-T', arch_linker_file, '-Wl,-m,elf_i386', '-Wl,-Map=info.map', '-Wl,-L,libgcc']
else
	compiler.get_id() == 'gcc'
	  c_args = ['-Wall', '-Wextra']
	  link_args = ['-T', arch_linker_file, '-Wl,-Map=info.map', '-lgcc']
endif

# Include directory
inc_dirs = include_directories('include')

# Executable
image = executable(
	'kernel.elf',
	asm_srcs, kernel_srcs,
	c_args : c_args,
	link_args : link_args,
	include_directories : inc_dirs,
	implicit_include_directories : false)
