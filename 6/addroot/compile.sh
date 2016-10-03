#!/bin/bash

echo '[+] Assembling with Nasm ...'
nasm -f elf32 -o $1.o $1.asm

#echo '[+] Assembling with GNU Assembler (as) ..'
#as $1.asm -o $1.o

echo '[+] Linking ...'
ld -o $1 $1.o

echo '[+] Done!'
