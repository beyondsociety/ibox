# Todo : add code for 32/64 bit detection
# Finds the assembler program Nasm
nasm = find_program('nasm', required: true)

# Assembler sources for ibox
sources = files('stub.s')

# Generator that creates object files from assembler
asm_gen = generator(nasm,
  output : '@BASENAME@.o',
  arguments : ['-f', 'elf32', '@INPUT@', '-o', '@OUTPUT@', '-F', 'dwarf'])

# Generator then processes the object files to assembler
asm_srcs = asm_gen.process(sources)
