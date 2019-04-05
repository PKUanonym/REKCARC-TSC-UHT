#coding=utf-8
import re
import os
import sys
import urllib
import urllib2
import Queue
import time
from urlparse import urljoin
from sgmllib import SGMLParser
from HTMLParser import HTMLParser
from htmlentitydefs import name2codepoint

root_page = "http://news.tsinghua.edu.cn/publish/thunews/index.html"
initial_page = root_page + ""

url_queue = Queue.Queue()
seen = set()

seen.add(initial_page)
url_queue.put(initial_page)

class MyHTMLParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.NowTag=''
        self.is_h1=False
        self.title=''
        self.article=''
    #检索开头标签
    def handle_starttag(self,tag,attrs):
        #print "Start tag:",tag
        if(tag=='title'):
            self.NowTag='title'
        if(tag=='h1'):
            self.is_h1=True
        if(tag=='article'):
            self.NowTag='article'
        #匹配里面的项
        #for attr in attrs:
        #    print "    attr:",attr
    #匹配结束标签
    def handle_endtag(self,tag):
        #print "End tag  :",tag
        if(tag=='title'):
            self.NowTag=''
        if(tag=='h1'):
            self.is_h1=False
        if(tag=='article'):
            self.NowTag=''
    #处理数据
    def handle_data(self,data):
        if(self.is_h1):
            self.title=data
        if(self.NowTag == 'article'):
            self.article=self.article+data

class ListName(SGMLParser):
    def __init__(self):
        SGMLParser.__init__(self)
        self.is_a = ""
        self.link = []
        self.Title=""
    def start_a(self, attrs):
        for (x,y) in attrs:
            if(x=='href' and y[-5:]=='.html' and y[:17]=='/publish/thunews/'):
                self.link.append(y)

spath = "news_201609101625.txt"
f = open(spath, "w")
cnt = 0
cur = 0
tmp_object = re.compile(r"/(\d{23})_")

while(url_queue.qsize()>0):
    current_url = url_queue.get()
    try:
        cur += 1
        html=urllib2.urlopen(current_url).read()
        listname = ListName()
        listname.feed(html)
        tmp_result = tmp_object.search(current_url)
        if tmp_result != None:
            parser = MyHTMLParser()
            parser.feed(html)
            cnt = cnt + 1
            str_id = tmp_result.group(1)
            f.write("cnt=" + str(cnt) + " : " +current_url + '^^^^\n' + parser.title + '^^^^' + parser.article + '@@@@' + '\n')
        linkList = [urljoin(current_url, i) for i in listname.link]
        for i in linkList:
            if i not in seen:
                url_queue.put(i)
                seen.add(i)
        print cur
    except :
        cur -= 1
        print "Error",cur

f.close()