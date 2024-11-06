;----------------------------------------------------------------------------------------
; Define constants for the Multiboot1 Header
;----------------------------------------------------------------------------------------
MULTIBOOT_PAGE_ALIGN	    equ 1 << 0   ; Align loaded modules on page boundaries
MULTIBOOT_MEMORY_INFO	  equ 1 << 1   ; Provide memory map
MULTIBOOT_VIDEO		      equ 1 << 2   ; Video Information

MULTIBOOT_HEADER_MAGIC	  equ 0x1badb002  ; 'magic number' lets bootloader find the header
MULTIBOOT_HEADER_FLAGS	  equ MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_VIDEO ; Multiboot flags
MULTIBOOT_HEADER_CHECKSUM equ - (MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS) ; Multiboot Checksum

[section .multiboot]
align 4
header1_start:
	dd MULTIBOOT_HEADER_MAGIC
	dd MULTIBOOT_HEADER_FLAGS
	dd MULTIBOOT_HEADER_CHECKSUM
	dd 0, 0, 0, 0, 0                     ; Aout kluge info - header_addr, load_addr, load_end_addr, bss_end_addr, entry_addr
	dd 1                                 ; 0 = linear graphics mode, 1 = EGA-standard text mode;dd 800, 600, 32                     ; Width (Horizontal pixels), Height (Vertical pixels), Bit Depth
 ;dd 80, 25, 0
header1_end:

;----------------------------------------------------------------------------------------
; Declare constants for the Multiboot2 header
;----------------------------------------------------------------------------------------
MULTIBOOT2_HEADER_MAGIC          equ 0xe85250d6   ; Magic field of multiboot header
MULTIBOOT_ARCHITECTURE_I386      equ 0            ; ISA:i386 arch field
MULTIBOOT_HEADER_TAG_END         equ 0            ; Multiboot2 tag end
MULTIBOOT_HEADER_TAG_FRAMEBUFFER equ 5            ; Framebuffer tag
MULTIBOOT_HEADER_TAG_OPTIONAL    equ 1            ; Optional header tag flag

HEADER_LENGTH equ header_end - header_start       ; Header length field
CHECKSUM      equ 0x100000000 - (MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (HEADER_LENGTH))

[section .multiboot2]
align 8
header_start:
  dd MULTIBOOT2_HEADER_MAGIC
  dd MULTIBOOT_ARCHITECTURE_I386
  dd HEADER_LENGTH
  dd CHECKSUM

; Information request
align 8
info_tag_start:
  dw 1                                          ; Type = 1
  dw 0                                          ; Flags (Optional)
  dd info_tag_end - info_tag_start              ; Size = (4 * 6 + 8)
  ; mbi_tag_types = array of u32s representing an info request
  dd 1                                          ; Command line
  dd 2                                          ; Modules
  dd 5                                          ; Bios boot-device
  dd 6                                          ; Memory map
  dd 8                                          ; Framebuffer
info_tag_end:

; Console
align 8
console_tag_start:
  dw 4                                          ; Type = 4
  dw 0                                          ; Flags
  dd console_tag_end - console_tag_start        ; Size  = 12
  dd 3    															        ; EGA text support, require console (Console: 0 + EGA text mode: 1) (0x03)
console_tag_end:

; Framebuffer Graphics
;align 8
;framebuffer_graphics_tag_start:
;  dw MULTIBOOT_HEADER_TAG_FRAMEBUFFER          ; Type = 5
;  dw 0                                         ; Flags (Optional, 0 = graphics)
;  dd framebuffer_graphics_tag_end - framebuffer_graphics_tag_start ; Size = 20
;  dd 800                                       ; Width (800)
;  dd 600                                       ; Height (600)
;  dd 32                                        ; Depth (32)

;align 8
;framebuffer_graphics_tag_end:
;  dw MULTIBOOT_HEADER_TAG_END                  ; Type
;  dw 0                                         ; Flags, none set
;  dd 8                                         ; Size, including itself (short + short + long)

; Framebuffer Text (there does not work since we havent written a framebuffer driver yet, use consols instead) 
;align 8
;framebuffer_text_tag_start:
;  dw MULTIBOOT_HEADER_TAG_FRAMEBUFFER          ; Type = 5
;  dw 1                                         ; Flags (Optional, 2 = EGA text mode)
;  dd framebuffer_text_tag_end - framebuffer_text_tag_start ; Size = 12
;  dd 80                                        ; Width (80)
;  dd 25                                        ; Height (25)
;  dd 0                                         ; Depth (0)

;align 8
;framebuffer_text_tag_end:
;  dw MULTIBOOT_HEADER_TAG_END                  ; Type
;  dw 0                                         ; Flags, none set
;  dd 8                                         ; Size, including itself (short + short + long)

align 8
; Terminating end tag
  dw MULTIBOOT_HEADER_TAG_END                   ; Type
  dw 0                                          ; Flags, none set
  dd 8                                          ; Size, including itself (short + short + long)

header_end:
