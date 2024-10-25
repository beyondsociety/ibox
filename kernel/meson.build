# Location of linker file (Todo: fix hardcoded paths)
if host_machine.cpu_family() == 'x86'
  linker_file = meson.global_source_root() + '/firmware/pc-bios/linker32.ld'
elif host_machine.cpu_family() == 'x86_64'
  linker_file = meson.global_source_root() + '/firmware/pc-bios/linker64.ld'
else
  error('Missing file: No linker script found for this platform')
endif

# Kernel sources
kernel_srcs = files(
	'bga.c', 'kernel.c',
	'io.c', 'multiboot.c',
	'stdio.c', 'string.c',
	'terminal.c', 'vsprintf.c')

# Pass compiler and linker args from cross-file to Ibox
if meson.is_cross_build()
  c_args = meson.get_external_property('c_args', 'native: false')
  link_args = meson.get_external_property('c_link_args', 'native: false')
endif

# Compiler options based on type of compiler used
compiler = meson.get_compiler('c')
  if compiler.get_id() == 'clang'
	  c_args = [ '-Wall', '-Wextra' ]
	  link_args = [ '-Wl,-T', linker_file, '-Wl,-Map=info.map', '-Wl,-L,libgcc' ]
  else
	compiler.get_id() == 'gcc'
	  c_args = [ '-Wall', '-Wextra' ]
	  link_args = [ '-T', linker_file, '-Wl,-Map=info.map', '-Wl,-L,libgcc' ]
    #link_args = [ '-T', arch_linker_file, '-Wl,-Map=info.map', '-lgcc' ]
  endif
