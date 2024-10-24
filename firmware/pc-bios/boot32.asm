[section .text]
global start
[bits 32]
start:
   cli  
  
   ;lidt [IDT]                        ; Load a zero length IDT so that any NMI causes a triple fault.
  ;sti

  ;jmp $

  ; Setup a kernel stack
  mov esp, stack_top

  push ebx
  push eax

  ;mov ebx, 0xb8000
  ;mov al, '!'
  ;mov ah, 0x1F
  ;mov [ebx], ax
  ;jmp $

  [extern kernel_init]
  call kernel_init

  cli
.halt:
  hlt
  jmp .halt

;ALIGN 4
;IDT:
;    .Length       dw 0
;    .Base         dd 0

[section .bss]
;align 4096
;align 16
stack_bottom:
; resb 16384
  resb 4096 * 16
stack_top:
