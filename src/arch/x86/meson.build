# Find Nasm
nasm = find_program('nasm', required: true)

# Generator that will take object files
asm_gen = generator(nasm,
        output : '@BASENAME@.o',
        arguments : ['-f', 'elf32', '@INPUT@', '-o', '@OUTPUT@'])

# Generators take in an array of files to generate
asm_sources = asm_gen.process(['stub.s'])



