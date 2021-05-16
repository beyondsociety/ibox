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
	dd 1                            ; 0 = linear graphics mode, 1 = EGA-standard text mode
;	dd 800, 600, 32                 ; Width (Horizontal pixels), Height (Vertical pixels), Bit Depth
  dd 80, 25, 0

;----------------------------------------------------------------------------------------
; Declare constants for the Multiboot2 header
;----------------------------------------------------------------------------------------
MULTIBOOT2_HEADER_MAGIC          equ 0xe85250d6   ; Magic field of mulitboot header
MULTIBOOT_ARCHITECTURE_I386      equ 0            ; ISA:i386 arch field
MULTIBOOT_HEADER_TAG_END         equ 0            ;
MULTIBOOT_HEADER_TAG_FRAMEBUFFER equ 5            ;

HEADER_LENGTH equ header_end - header_start       ; Header length field
CHECKSUM      equ 0x100000000 - (MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (HEADER_LENGTH))

[section .multiboot2]
align 8
header_start:
  dd MULTIBOOT2_HEADER_MAGIC
  dd MULTIBOOT_ARCHITECTURE_I386
  dd HEADER_LENGTH
  dd CHECKSUM

info_tag_start:
  dw 1
	dw 0
	dd info_tag_end - info_tag_start
	dd 1
	dd 2
	dd 6
info_tag_end:

;----------------------------------------
; Console
;----------------------------------------
;align 8
;console_tag_start:
; dw 4
;	dw 0
;	dd console_tag_end - console_tag_start
;	dd 0x03   ; Console + EGA text mode
;console_tag_end:

;-------------------------------------
; Framebuffer Graphics
;-------------------------------------
; framebuffer_graphics_tag
;framebuffer_tag_start:
;  dw MULTIBOOT_HEADER_TAG_FRAMEBUFFER
;  dw 0
;  dd framebuffer_tag_end - framebuffer_tag_start 	; 20
;  dd 800
;  dd 600
;  dd 32
;align 8

;framebuffer_tag_end:
;  dw MULTIBOOT_HEADER_TAG_END ; Type
;  dw 0                        ; Flags, none set
;  dd 8                        ; Size, including itself (short + short + long)
;header_end:

;align 8
; framebuffer_text_tag
;framebuffer_tag_start:
;  dw MULTIBOOT_HEADER_TAG_FRAMEBUFFER
;  dw 1
;  dd framebuffer_tag_end - framebuffer_tag_start   ; 12
;  dd 80
;  dd 25
;  dd 0
;framebuffer_tag_end:

align 8
;end_tag_start:
  dw MULTIBOOT_HEADER_TAG_END ; Type
  dw 0                        ; Flags, none set
  dd 8                        ; Size, including itself (short + short + long)
;end_tag_end:

header_end:
