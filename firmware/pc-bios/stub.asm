[section .bss]
align 16
stack_bottom:
	resb 16384
stack_top:

[section .text]
global start
start:
	mov esp, stack_top

;	mov ebx, 0xb8000
;	mov al, '!'
;	mov ah, 0x1F
;	mov [ebx], ax
;	jmp $

;	push eax
;	push ebx

	push ebx
  push eax

	[extern kernel_init]
	call kernel_init

	cli
.halt:
	hlt
	jmp .halt
