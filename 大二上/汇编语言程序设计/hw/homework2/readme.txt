---
董胤蓬
2013011367
2015/8/25
---

linux.s, record-def.s : 常量定义文件

write-record.s write-records.s : 写记录文件，按要求格式写入四个数据

write : write-record.s write-records.s编译出得可执行程序

input.dat : 数据文件，write程序写入的数据，用于修改记录的输入

read-record.s read-records.s : 修改数据文件，读入数据并使年龄++，并写出到output.dat中

read : read-record.s read-records.s编译出的可执行程序

output.dat : read的输出结果