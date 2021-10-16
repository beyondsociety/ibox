bits 32
check_multiboot2:
  cmp eax, 0x36d76289
  jne .no_multiboot2
  ret

.no_multiboot2:
  mov al, "1"
  jmp error

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
  mov al, "2"
  jmp error

check_long_mode:
  ; Test if extended processor info in available
  mov eax, 0x80000000    ; Implicit argument for cpuid
  cpuid                  ; Get highest supported argument
  cmp eax, 0x80000001    ; It needs to be at least 0x80000001
  jb .no_long_mode       ; If it's less, the CPU is too old for long mode

  ; Use extended info to test if long mode is available
  mov eax, 0x80000001    ; Argument for extended processor info
  cpuid                  ; Returns various feature bits in ecx and edx
  test edx, 1 << 29      ; Test if the LM-bit is set in the D-register
  jz .no_long_mode       ; If it's not set, there is no long mode
  ret

.no_long_mode:
  mov al, "3"
  jmp error

set_up_page_tables:
  ; Map first P4 entry to P3 table
  mov eax, p3_table
  or eax, 0b11 ; present + writable
  mov [p4_table], eax

  ; Map first P3 entry to P2 table
  mov eax, p2_table
  or eax, 0b11 ; present + writable
  mov [p3_table], eax

  ; Map each P2 entry to a huge 2MiB page
  mov ecx, 0         ; counter variable

.map_p2_table:
  ; Map ecx-th P2 entry to a huge page that starts at address 2MiB*ecx
  mov eax, 0x200000  ; 2MiB
  mul ecx            ; start address of ecx-th page
  or eax, 0b10000011 ; present + writable + huge
  mov [p2_table + ecx * 8], eax ; map ecx-th entry

  inc ecx            ; increase counter
  cmp ecx, 512       ; if counter == 512, the whole P2 table is mapped
  jne .map_p2_table  ; else map the next entry

  ret

enable_paging:
  ; Load P4 to cr3 register (cpu uses this to access the P4 table)
  mov eax, p4_table
  mov cr3, eax

  ; Enable PAE-flag in cr4 (Physical Address Extension)
  mov eax, cr4
  or eax, 1 << 5
  mov cr4, eax

  ; Set the long mode bit in the EFER MSR (model specific register)
  mov ecx, 0xC0000080
  rdmsr
  or eax, 1 << 8
  wrmsr

  ; Enable paging in the cr0 register
  mov eax, cr0
  or eax, 1 << 31
  mov cr0, eax

  ret

; Prints `ERR: ` and the given error code to screen and hangs.
; parameter: error code (in ascii) in al
error:
  mov dword [0xb8000], 0x4f524f45
  mov dword [0xb8004], 0x4f3a4f52
  mov dword [0xb8008], 0x4f204f20
  mov byte  [0xb800a], al
  hlt
