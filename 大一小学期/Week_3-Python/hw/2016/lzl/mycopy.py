#coding=utf-8
from jieba import cut_for_search
import os
import re
import sys

class data():
    def __init__(self):
        self.id = 0
        self.url = ""
        self.title = ""
        self.time = ""
        self.body = ""

data_list = list()

tmp_object = re.compile(r"cnt=(\d+) : (http\S*).*\^\^\^\^\n   (\S*)(.*)(\d\d\d\d年\d\d月\d\d日 \d\d:\d\d:\d\d)",re.S)
fin = open("news_201609101625.txt", "r")
fout = open("new_news.txt", "w")
string = fin.read()
fin.close()
mylist = string.split("@@@@")
cnt = 0
whole_body  = ""
word_list = list()


for s in mylist:
    s = s.strip()
    cur = data()
    tmp_result = tmp_object.search(s)
    if tmp_result != None:
        cnt += 1
        cur.id = cnt
        cur.url = tmp_result.group(2)
        cur.title = tmp_result.group(3)
        cur.body = tmp_result.group(4)
        cur.time = tmp_result.group(5)
        cur.body = cur.body.replace('\n','')
        cur.title = cur.title.replace('\n','')
        """
        tmp_list = cut_for_search(cur.title+' '+cur.body)
        tmp_list = [i.encode("UTF-8") for i in tmp_list]
        word_list = list(set(word_list) | set(tmp_list))
        """
        fout.write('id:'+str(cur.id)+' url:'+cur.url+' title:'+cur.title+' body:'+cur.body+' time:'+cur.time+'@@@@\n')

fout.close()
"""
#统计
fout = open("word.txt","w")
for c in word_list:
    fout.write(c+'\n')
fout.close()
"""


