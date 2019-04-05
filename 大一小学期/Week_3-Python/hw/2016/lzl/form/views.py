from django.shortcuts import render
from django.shortcuts import get_object_or_404, render
from django.http import HttpResponseRedirect, HttpResponse
#from django.urls import reverse
from django.core.urlresolvers import reverse
from django.views import generic
import cPickle as pickle
import re
import json
from jieba import lcut_for_search

word_dict = dict()

class outputdata():
    def __init__(self):
        self.url = ""
        self.title = ""

with open("index.pkl","rb") as f:
    word_dict = pickle.load(f)
with open("new_news.txt","r") as f:
    text= f.read()
text_list = text.split("@@@@")
tmp_object = re.compile(r"id:(\d+) url:(http\S*)\^\^\^\^ title:(\S*) body")
url_dict = dict()
title_dict = dict()
for s in text_list:
    re_out = tmp_object.search(s)
    if re_out != None:
        id = int(re_out.group(1))
        url = re_out.group(2)
        title = re_out.group(3)
        url_dict[id] = url
        title_dict[id] = title

def index(request):
    return render(request, 'form/index.html')

def find(request):
    key_word=request.POST["url_text"]
    key_word
    if key_word != None:
        key_list = lcut_for_search(key_word)
        key_list = list(set(key_list))
        #key_list = [i.encode("UTF-8") for i in key_list]
        ans_list = range(1,49176)
        for s in key_list:
            if word_dict.has_key(s):
                cur_list = word_dict[s]
                ans_list = list(set(ans_list) & set(cur_list))
            else:
                ans_list = list()
                break
        mylist = list()
        #print len(ans_list)
        for c in ans_list:
            try:
                tmplist = outputdata()
                tmplist.url = url_dict[c]
                tmplist.title = title_dict[c]
                mylist.append(tmplist)
                if len(mylist) >= 1000:
                    break
            except:
                print("Error ",c)
        return render(request, 'form/result.html', {'anslist':mylist})

# Create your views here.
