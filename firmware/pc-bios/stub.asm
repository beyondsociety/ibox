%include '../firmware/pc-bios/functions.inc'

[section .text]
global start
bits 32
start:
  mov edi, ebx ; Address of multiboot structure
  mov esi, eax ; Magic number

	mov esp, stack_top

  ;call check_multiboot2
  call check_cpuid
  call check_long_mode

  call set_up_page_tables
  call enable_paging

  ; Load the 64-bit GDT
  lgdt [gdt64.pointer]

  [extern longmode_start]
  jmp gdt64.code:longmode_start

[section .rodata]
gdt64:
    dq 0 ; zero entry
.code: equ $ - gdt64 ; new
    dq (1<<43) | (1<<44) | (1<<47) | (1<<53) ; code segment

.pointer:
    dw $ - gdt64 - 1
    dq gdt64

[section .bss]
  align 4096    ; Was align 16
p4_table:
  resb 4096
p3_table:
  resb 4096
p2_table:
  resb 4096
stack_bottom:
  resb 64       ; Was resb 16384
stack_top:
