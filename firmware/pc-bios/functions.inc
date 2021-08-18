check_multiboot:
  cmp eax, 0x2BADB002
	jne .no_multiboot
  ret

.no_multiboot:
  ;mov al, '0'
	;mov bl, 'M'
  jmp error

  error:
    mov dword [0xb8000], 0x4f524f45
  	mov dword [0xb8004], 0x4f3a4f52
  	mov dword [0xb8008], 0x4f204f20
  	mov byte [0xb800a], al
  	mov byte [0xb800c], bl
    mov word [0xb800d], 0x4f

    jmp $
