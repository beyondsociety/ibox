;----------------------------------------------------------------------------------------
; Define constants for the Multiboot1 Header
;----------------------------------------------------------------------------------------
MULTIBOOT_PAGE_ALIGN	    equ 1 << 0   ; Align loaded modules on page boundaries
MULTIBOOT_MEMORY_INFO	    equ 1 << 1   ; Provide memory map
MULTIBOOT_VIDEO		        equ 1 << 2   ; Video Information

MULTIBOOT_HEADER_MAGIC	  equ 0x1badb002 ; 'magic number' lets bootloader find the header
MULTIBOOT_HEADER_FLAGS	  equ MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_VIDEO ; Multiboot flags
MULTIBOOT_HEADER_CHECKSUM equ - (MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS) ; Multiboot Checksum

[section .multiboot]
align 4
	dd MULTIBOOT_HEADER_MAGIC
	dd MULTIBOOT_HEADER_FLAGS
	dd MULTIBOOT_HEADER_CHECKSUM
	dd 0, 0, 0, 0, 0                ; Aout kluge info - header_addr, load_addr, load_end_addr, bss_end_addr, entry_addr
	dd 0                            ; 0 = linear graphics mode, 1 = EGA-standard text mode
	dd 800, 600, 32                 ; Width (Horizontal pixels), Height (Vertical pixels), Bit Depth

;----------------------------------------------------------------------------------------
; Declare constants for the Multiboot2 header
;----------------------------------------------------------------------------------------
MULTIBOOT2_HEADER_MAGIC          equ 0xe85250d6
MULTIBOOT_ARCHITECTURE_I386      equ 0
MULTIBOOT_HEADER_TAG_END         equ 0
MULTIBOOT_HEADER_TAG_FRAMEBUFFER equ 5

HEADER_LENGTH equ header_end - header_start
CHECKSUM      equ 0x100000000 - (MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + HEADER_LENGTH)

[section .multiboot2]
align 8
header_start:
  dd MULTIBOOT2_HEADER_MAGIC
  dd MULTIBOOT_ARCHITECTURE_I386
  dd HEADER_LENGTH
  dd CHECKSUM

;-------------------------------------
; multiboot tags go here
;-------------------------------------
; framebuffer_tag
  dw MULTIBOOT_HEADER_TAG_FRAMEBUFFER
  dw 0
  dd 20
  dd 800
  dd 600
  dd 32
align 8

  dw MULTIBOOT_HEADER_TAG_END ; Type
  dw 0                        ; Flags, none set
  dd 8                        ; Size, including itself (short + short + long)
header_end:
