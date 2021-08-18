%include "../firmware/pc-bios/functions.inc"

[section .text]
global start
[bits 32]
start:
  ;call check_multiboot

	mov edi, ebx        ; Address of multiboot structure
  mov esi, eax        ; Magic number

  ; Setup a kernel stack
  mov esp, stack_top

	; Point the first entry of the level 4 page table to the first entry in the p3 table
  mov eax, p3_table
  or eax, 0b11 ; present + writable
  mov dword [p4_table], eax

  ; Point the first entry of the level 3 page table to the first entry in the p2 table
  mov eax, p2_table
  or eax, 0b11
  mov dword [p3_table], eax

  ; Point each page table level two entry to a page
  mov ecx, 0         ; Counter variable
.map_p2_table:
	mov eax, 0x200000  ; 2MiB
  mul ecx
  or eax, 0b10000011
  mov [p2_table + ecx * 8], eax

  inc ecx
  cmp ecx, 512
  jne .map_p2_table

  ; Move page table address to cr3
  mov eax, p4_table
  mov cr3, eax

  ;mov edi, 0x1000    ; Set the destination index to 0x1000.
  ;mov cr3, edi       ; Set control register 3 to the destination index.
  ;xor eax, eax       ; Nullify the A-register.
  ;mov ecx, 4096      ; Set the C-register to 4096.
  ;rep stosd          ; Clear the memory.
  ;mov edi, cr3       ; Set the destination index to control register 3.

  ;mov DWORD [edi], 0x2003      ; Set the uint32_t at the destination index to 0x2003.
  ;add edi, 0x1000              ; Add 0x1000 to the destination index.
  ;mov DWORD [edi], 0x3003      ; Set the uint32_t at the destination index to 0x3003.
  ;add edi, 0x1000              ; Add 0x1000 to the destination index.
  ;mov DWORD [edi], 0x4003      ; Set the uint32_t at the destination index to 0x4003.
  ;add edi, 0x1000              ; Add 0x1000 to the destination index.

  ;mov ebx, 0x00000003          ; Set the B-register to 0x00000003.
  ;mov ecx, 512                 ; Set the C-register to 512.

;.SetEntry:
  ;mov DWORD [edi], ebx         ; Set the uint32_t at the destination index to the B-register.
  ;add ebx, 0x1000              ; Add 0x1000 to the B-register.
  ;add edi, 8                   ; Add eight to the destination index.
  ;loop .SetEntry               ; Set the next entry.

  ; Enable PAE
  mov eax, cr4
  or eax, 1 << 5
  mov cr4, eax

  ; Set the long mode bit
  mov ecx, 0xC0000080
  rdmsr
  or eax, 1 << 8
  wrmsr

  ; Enable paging
  mov eax, cr0
  ;or eax, (1 << 31 | 1 << 16)
	or eax, 1 << 31
  mov cr0, eax

  lgdt [GDT64.Pointer]         ; Load the 64-bit global descriptor table.
  jmp GDT64.Code:Realm64       ; Set the code segment and enter 64-bit long mode.

  ; Long jump to long-mode setting `cs` register to `gdt64.code`
	;jmp gdt64.code:long_mode_start

; Use 64-bit
[bits 64]
Realm64:
  cli                           ; Clear the interrupt flag.
  mov ax, GDT64.Data            ; Set the A-register to the data descriptor.
	mov ss, ax
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  ; Restore
	push rdi
	push rsi

  [extern kernel_init]
  call kernel_init

	cli
.halt:
	hlt
	jmp .halt

[section .rodata]
GDT64:                         ; Global Descriptor Table (64-bit).
.Null: equ $ - GDT64           ; The null descriptor.
  dw 0xFFFF                    ; Limit (low).
  dw 0                         ; Base (low).
  db 0                         ; Base (middle)
  db 0                         ; Access.
  db 1                         ; Granularity.
  db 0                         ; Base (high).

.Code: equ $ - GDT64           ; The code descriptor.
  dw 0                         ; Limit (low).
  dw 0                         ; Base (low).
  db 0                         ; Base (middle)
  db 10011010b                 ; Access (exec/read).
  db 10101111b                 ; Granularity, 64 bits flag, limit19:16.
  db 0                         ; Base (high).

.Data: equ $ - GDT64           ; The data descriptor.
  dw 0                         ; Limit (low).
  dw 0                         ; Base (low).
  db 0                         ; Base (middle)
  db 10010010b                 ; Access (read/write).
  db 00000000b                 ; Granularity.
  db 0                         ; Base (high).

.Pointer:                      ; The GDT-pointer.
  dw $ - GDT64 - 1             ; Limit.
  dq GDT64                     ; Base.

[section .bss]
  align 4096
p4_table:
  resb 4096
p3_table:
  resb 4096
p2_table:
  resb 4096

  align 4096
stack_bottom:
  resb 16384
stack_top:
