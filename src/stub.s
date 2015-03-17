; Multiboot Header 
MULTIBOOT_PAGE_ALIGN      equ  1 << 0   ; Align loaded modules on page boundaries
MULTIBOOT_MEMORY_INFO     equ  1 << 1   ; Provide memory map
MULTIBOOT_VIDEO           equ  1 << 2   ; Video Information

MULTIBOOT_HEADER_MAGIC    equ  0x1badb002  ; 'magic number' lets bootloader find the header
MULTIBOOT_HEADER_FLAGS    equ  MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_VIDEO ; Multiboot flags  
MULTIBOOT_HEADER_CHECKSUM equ  - (MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS) ; Multiboot Checksum 

[section .multiboot]
align 4
  dd MULTIBOOT_HEADER_MAGIC
  dd MULTIBOOT_HEADER_FLAGS
  dd MULTIBOOT_HEADER_CHECKSUM
  dd 0, 0, 0, 0, 0                      ; Aout kluge info - header_addr, load_addr, load_end_addr, bss_end_addr, entry_addr 
  dd 1                                  ; 0 = linear graphics mode, 1 = EGA-standard text mode
  dd 1024, 768, 32                      ; Width, Height, Depth

[section .text]
[global start]
start:                       
    mov esp, stack_top

;    call check_cpu                       ; Check whether we support Long Mode or not.
;    jc no_longmode

;    call longmode
    
;[bits 64]
;.long:    
;    push rax
;    push rbx  

    push eax
    push ebx 
         
    [extern sys_multiboot_info]
;    mov rbx, sys_multiboot_info
    mov ebx, sys_multiboot_info

    [extern kernel_init]
    call kernel_init
    
    cli
    hlt
    
.hang:
    jmp .hang
    
;[bits 32]
;no_longmode:
;    mov byte [ds:0b8000h], 'F'
;    mov byte [ds:0b8001h], 1bh
;   jmp $
    
;%include "src/functions.inc"   
 
[section .bss]				; .BSS section 
align 4
stack_bottom:
  resb 16384 					
stack_top:


