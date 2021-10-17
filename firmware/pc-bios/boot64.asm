%include "../firmware/pc-bios/functions.inc"

[section .text]
global start
[bits 32]
start:
  ; Setup a kernel stack
  mov esp, stack_top

  ; Save multiboot values for later
  mov edi, ebx                        ; Address of multiboot structure
  mov esi, eax                        ; Magic number

  ;call check_cpuid
  call check_long_mode

  call setup_page_tables              ; Setup page tables
  call enable_paging                  ; Enable paging

  ; Load the 64-bit GDT
  ; lgdt [gdt64.pointer]

  ; jmp gdt64.code:longmode_start

  lgdt [GDT64.Pointer]                ; Load the 64-bit global descriptor table.
  jmp GDT64.Code:longmode_start       ; Set the code segment and enter 64-bit long mode.

  ; Long jump to long-mode setting `cs` register to `gdt64.code`
	; jmp gdt64.code:longmode_start

[bits 64]
longmode_start:
  ; cli                               ; Clear the interrupt flag.
  mov ax, GDT64.Data                  ; Set the A-register to the data descriptor.
  ; mov ax, 0
	mov ss, ax
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  ; Restore Multiboot values
	push rdi
	push rsi

  ; Print `OKAY` to screen
  ; mov rax, 0x2f592f412f4b2f4f
  ; mov qword [0xb8000], rax
  ; hlt

  ; Jump to kernel
  [extern kernel_init]
  call kernel_init

	cli
.halt:
	hlt
	jmp .halt

[section .rodata]
GDT64:                              ; Global Descriptor Table (64-bit)
.Null: equ $ - GDT64                ; The null descriptor
  dw 0xFFFF                         ; Limit (low)
  dw 0                              ; Base (low)
  db 0                              ; Base (middle)
  db 0                              ; Access.
  db 0                              ; Granularity, (was 1)
  db 0                              ; Base (high)

.Code: equ $ - GDT64                ; The code descriptor.
  dw 0xFFFF                         ; Limit (low), (was 0)
  dw 0                              ; Base (low)
  db 0                              ; Base (middle)
  db 10011010b                      ; Access (exec/read)
  db 10101111b                      ; Granularity, 64 bits flag, limit19:16
  db 0                              ; Base (high)

.Data: equ $ - GDT64                ; The data descriptor
  dw 0xFFFF                         ; Limit (low), (was 0)
  dw 0                              ; Base (low)
  db 0                              ; Base (middle)
  db 10010010b                      ; Access (read/write)
  db 00000000b                      ; Granularity
  db 0                              ; Base (high)

.Pointer:                           ; The GDT-pointer
  dw $ - GDT64 - 1                  ; Limit
  dq GDT64                          ; Base

; gdt64:
;  dq 0                             ; Zero entry
; .code: equ $ - gdt64 ; new
;  dq (1<<43) | (1<<44) | (1<<47) | (1<<53) ; Code segment
; .pointer:
;  dw $ - gdt64 - 1
;  dq gdt64

[section .bss]
align 4096
p4_table:
  resb 4096
p3_table:
  resb 4096
p2_table:
  resb 4096

; align 4096
stack_bottom:
  ; resb 16384
  resb 64
stack_top:
