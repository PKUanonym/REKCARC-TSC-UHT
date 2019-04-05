import os
import sys
import re
import json
import cPickle as pickle
from jieba import lcut_for_search

intext = open("new_news.txt","r")
text = intext.read()
text_list = text.split("@@@@")
intext.close()

word_dict = dict()
re_obj = re.compile(r"id:(\d+).*title:(.*) body:(.*) time:")
cnt = 0
word_list = list()
for text in text_list:
    cnt += 1
    print cnt
    try:
        re_out = re_obj.search(text)
        if re_out != None:
            id = int(re_out.group(1))
            title = re_out.group(2)
            body = re_out.group(3)
            tmp_list = lcut_for_search(title + ' ' + body)
            #print len(tmp_list)
            #tmp_list = [i.encode("UTF-8") for i in tmp_list]
            #word_list = list(set(word_list) | set(tmp_list))
            tmp_list = list(set(tmp_list))
            for i in tmp_list:
                if word_dict.has_key(i):
                    cnt_list = word_dict[i]
                else:
                    cnt_list = list()
                    word_list.append(i)
                cnt_list.append(id)
                word_dict[i] = cnt_list
    except:
        cnt -= 1
        print "Error"

encodedjson = json.dumps(word_dict)
with open('index.pkl', 'wb') as f:
    f.write(encodedjson)
