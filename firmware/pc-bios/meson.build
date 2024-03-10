# Find the assembler program Nasm
nasm = find_program('nasm', required: true)

# Assembler sources for ibox
sources32 = files('multiboot_headers.asm', 'boot32.asm')
sources64 = files('multiboot_headers.asm', 'boot64.asm')

if host_machine.cpu_family() == 'x86'
  asm_format = 'elf32'
elif host_machine.cpu_family() == 'x86_64'
  asm_format = 'elf64'
endif

# Generator that creates object files from assembler
asm_gen = generator(nasm,
  output : '@BASENAME@.o',
  arguments : [ '-f', asm_format, '@INPUT@', '-o', '@OUTPUT@', '-F', 'dwarf' ])

# Generator then processes the object files to assembler
if host_machine.cpu_family() == 'x86'
  asm_srcs = asm_gen.process(sources32)
elif host_machine.cpu_family() == 'x86_64'
  asm_srcs = asm_gen.process(sources64)
endif
