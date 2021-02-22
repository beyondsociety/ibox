;[section .bss]
;align 16
;stack_bottom:
;	resb 16384
;stack_top:

[section .text]
global start
start:
;	mov esp, stack_top

  push ebx
  push eax

  mov word [0xb8000], 0x0248 ; H
  hlt

;  [extern kernel_init]
;  call kernel_init

	cli
.halt:
	hlt
	jmp .halt
