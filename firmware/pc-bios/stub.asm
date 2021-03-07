[section .text]
global start
start:
	mov esp, stack_top

  push ebx
  push eax

  [extern kernel_init]
  call kernel_init

	cli
.halt:
	hlt
	jmp .halt

[section .bss]
  align 16
stack_bottom:
  	resb 16384
stack_top:
