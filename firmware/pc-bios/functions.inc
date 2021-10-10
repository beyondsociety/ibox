[bits 32]
; Check for CPUID
check_cpuid:
  ; Check if CPUID is supported by attempting to flip the ID bit (bit 21)
  ; in the FLAGS register. If we can flip it, CPUID is available.

  ; Copy FLAGS in to EAX via stack
  pushfd
  pop eax

  ; Copy to ECX as well for comparing later on
  mov ecx, eax

  ; Flip the ID bit
  xor eax, 1 << 21

  ; Copy EAX to FLAGS via the stack
  push eax
  popfd

  ; Copy FLAGS back to EAX (with the flipped bit if CPUID is supported)
  pushfd
  pop eax

  ; Restore FLAGS from the old version stored in ECX (i.e. flipping the
  ; ID bit back if it was ever flipped).
  push ecx
  popfd

  ; Compare EAX and ECX. If they are equal then that means the bit
  ; wasn't flipped, and CPUID isn't supported.
  cmp eax, ecx
  je .no_cpuid
  ret

.no_cpuid:
  mov al, "1"
  jmp error

; Check for long-mode
check_long_mode:
  ; test if extended processor info in available
  mov eax, 0x80000000    ; implicit argument for cpuid
  cpuid                  ; get highest supported argument
  cmp eax, 0x80000001    ; it needs to be at least 0x80000001
  jb .no_long_mode       ; if it's less, the CPU is too old for long mode

  ; use extended info to test if long mode is available
  mov eax, 0x80000001    ; argument for extended processor info
  cpuid                  ; returns various feature bits in ecx and edx
  test edx, 1 << 29      ; test if the LM-bit is set in the D-register
  jz .no_long_mode       ; If it's not set, there is no long mode
  ret
.no_long_mode:
  mov al, "2"
  jmp error

; Prints `ERR: ` and the given error code to screen and hangs.
; parameter: error code (in ascii) in al
error:
  mov dword [0xb8000], 0x4f524f45
  mov dword [0xb8004], 0x4f3a4f52
  mov dword [0xb8008], 0x4f204f20
  mov byte [0xb800a], al
  ;mov byte [0xb800c], bl
  ;mov word [0xb800d], 0x4f
  hlt

; Setup page tables
setup_page_tables:
  ; Point the first entry of the level 4 page table to the first entry in the p3 table
  mov eax, p3_table
  or eax, 0b11              ; present + writable
  mov [p4_table], eax

  ; Point the first entry of the level 3 page table to the first entry in the p2 table
  mov eax, p2_table
  or eax, 0b11
  mov [p3_table], eax

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
  ret

; Enable paging
enable_paging:
  ; load P4 to cr3 register (cpu uses this to access the P4 table)
  mov eax, p4_table
  mov cr3, eax

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
  ret
