#!/usr/bin/python  
#-*- coding: utf-8 -*-  
  
from pdfminer.converter import PDFPageAggregator  
from pdfminer.pdfparser import PDFParser  
from pdfminer.pdfdocument import PDFDocument  
from pdfminer.pdfpage import PDFPage  
from pdfminer.pdfpage import PDFTextExtractionNotAllowed  
from pdfminer.pdfinterp import PDFResourceManager  
from pdfminer.pdfinterp import PDFPageInterpreter  
from pdfminer.layout import *  
import pandas as pd  
import re  
import csv  
  
  
csvfile = file('csv_test.csv', 'wb')  
writer = csv.writer(csvfile)  
writer.writerow(['Rank', 'Sovereign state/dependency', 'Total in km2 (mi2)', 'Land in km2 (mi2)'])  
# df = pd.DataFrame(columns=[u'区域信息', u'学校名称', u'考生姓名', u'性别', u'学号', u'专业名称'])  
# 打开一个pdf文件  
fp = open("./area.pdf", 'rb')  
#   创建一个PDF文档解析器对象  
parser = PDFParser(fp)  
# 创建一个PDF文档对象存储文档结构  
# 提供密码初始化，没有就不用传该参数  
# document = PDFDocument(parser, password)  
document = PDFDocument(parser)  
# 检查文件是否允许文本提取  
if not document.is_extractable:  
    raise PDFTextExtractionNotAllowed  
# 创建一个PDF资源管理器对象来存储共享资源  
# caching = False不缓存  
rsrcmgr = PDFResourceManager(caching=False)  
# 创建一个PDF设备对象  
laparams = LAParams()  
# 创建一个PDF页面聚合对象  
device = PDFPageAggregator(rsrcmgr, laparams=laparams)  
# 创建一个PDF解析器对象  
interpreter = PDFPageInterpreter(rsrcmgr, device)  
# 处理文档当中的每个页面  
# doc.get_pages() 获取page列表  
#for i, page in enumerate(document.get_pages()):  
#PDFPage.create_pages(document) 获取page列表的另一种方式  
replace = re.compile(r'\s+')  
page_cnt = 0  
# 循环遍历列表，每次处理一个page的内容  
for page in PDFPage.create_pages(document):  
    page_cnt += 1  
    interpreter.process_page(page)  
    # 接受该页面的LTPage对象  
    layout = device.get_result()  
    # 这里layout是一个LTPage对象 里面存放着 这个page解析出的各种对象  
    # 一般包括LTTextBox, LTFigure, LTImage, LTTextBoxHorizontal 等等  
    # if page_cnt == 1:  
    #     row_num = 34  
    # else:  
    #     row_num = 36  
    page_list = list()  
    for x in layout:  
        # 如果x是水平文本对象的话  
        if isinstance(x, LTTextBoxHorizontal):  
            text = x.get_text()  
            page_list.append(text.encode('utf-8'))  
            # text=re.sub(replace,'',x.get_text())  
            # if len(text) != 0:  
            #     print text  
    #page_list = page_list[]  
    cut_point = len(page_list) / 4
    data = [ele for ele in zip(page_list[0:cut_point], page_list[cut_point:cut_point*2], page_list[cut_point*2:cut_point*3],\
                               page_list[cut_point*3:cut_point*4])]  
    writer.writerows(data)  
  
csvfile.close()  


# # -*- coding: utf-8 -*-   
# from pdfminer.pdfparser import PDFParser
# from pdfminer.pdfdocument import PDFDocument
# from pdfminer.pdfpage import PDFPage
# from pdfminer.pdfpage import PDFTextExtractionNotAllowed
# from pdfminer.pdfinterp import PDFResourceManager
# from pdfminer.pdfinterp import PDFPageInterpreter
# from pdfminer.pdfdevice import PDFDevice
# from pdfminer.layout import *
# from pdfminer.converter import PDFPageAggregator
# import os
# os.chdir(r'F:\test')
# fp = open('python.pdf', 'rb')
# #来创建一个pdf文档分析器
# parser = PDFParser(fp)  
# #创建一个PDF文档对象存储文档结构
# document = PDFDocument(parser)
# # 检查文件是否允许文本提取
# if not document.is_extractable:
#     raise PDFTextExtractionNotAllowed
# else:
#     # 创建一个PDF资源管理器对象来存储共赏资源
#     rsrcmgr=PDFResourceManager()
#     # 设定参数进行分析
#     laparams=LAParams()
#     # 创建一个PDF设备对象
#     # device=PDFDevice(rsrcmgr)
#     device=PDFPageAggregator(rsrcmgr,laparams=laparams)
#     # 创建一个PDF解释器对象
#     interpreter=PDFPageInterpreter(rsrcmgr,device)
#     # 处理每一页
#     for page in PDFPage.create_pages(document):
#         interpreter.process_page(page)
#         # 接受该页面的LTPage对象
#         layout=device.get_result()
#         for x in layout:
#             if(isinstance(x,LTTextBoxHorizontal)):
#                 with open('a.txt','a') as f:
#                     f.write(x.get_text().encode('utf-8')+'\n')
