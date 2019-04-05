#coding=utf-8
import sys  
reload(sys)  
sys.setdefaultencoding('utf8')
from bs4 import BeautifulSoup
import os
import subprocess
import chardet
from xml.sax.saxutils import escape

xmlfile = open('index_pdf.xml', 'w')
def generate_index():
	pass

# web_count = 0
# f = open('node_id', 'w')
def add_file(root_dir):
	# global web_count
	# global f 
	for lists in os.listdir(root_dir):
		path = os.path.join(root_dir, lists)
		# print os.path.dirname(path)

		if os.path.isdir(path):
			add_file(path)
		else:

			filename = os.path.basename(path)
			if filename!=".DS_Store":
				# print filename
				f.write(path[7:]+' '+str(web_count)+'\n')
				web_count += 1

def process_content(s):
	s = ' '.join(s.split())
	s = ''.join(s.split('\''))
	s = ''.join(s.split('\"'))
	s = ''.join(s.split('\n'))
	for i in range(33):
		s = ''.join(s.split(chr(i)))
	s = escape(s)
	return s

def gen_graph(filename, index, index_dict, f):
	if (os.path.isfile(filename)):	
		soup = BeautifulSoup(open(filename), 'lxml')
		if soup.title:
			# print soup.title.text
			title = process_content(soup.title.text)
			# 处理超链接， 获取锚文本
			anchor_list = []
			# 生成链接
			link_list = []
			for a in soup.find_all('a'):
				if 'href' in a.attrs and a.string:
					href = a.attrs['href'][7:]
					if href[0:7] == 'http://':
						href = href[7:]
					# print href, a.string
					# 锚文本
					anchor_list.append(a.string)
					if href in index_dict:
						link_list.append(index_dict[href])
						
					else:
						if href+'index.html' in index_dict:
							link_list.append(index_dict[href+'index.html'])
			if len(link_list) > 0:
				f.write(index+':'+','.join(link_list)+'\n')
		return 


def parse_html(filename, index, index_dict, pr):
	f = open('graph', 'w')
	if (os.path.isfile(filename)):	
		soup = BeautifulSoup(open(filename), 'lxml')
		if soup.title:
			# print soup.title.text
			title = process_content(soup.title.text)
			# 处理超链接， 获取锚文本
			anchor_list = []
			# 生成链接
			link_list = []
			for a in soup.find_all('a'):
				if 'href' in a.attrs and a.string:
					# print a.attrs['href'], a.string
					href = a.attrs['href']

					if href[0:7] == 'http://':
						href = href[7:]
					href = filename[7:]+href
					# 锚文本
					anchor_list.append(a.string)
					if href in index_dict:
						link_list.append(index_dict[href])
					else:
						if href+'index.html' in index_dict:
							link_list.append(index_dict[href+'index.html'])
			if len(link_list) > 0:
				f.write(index+':'+','.join(link_list)+'\n')

			anchor = ' '.join([process_content(k) for k in anchor_list])
			
			# 处理h1-h6
			h = [0]

			for i in range(1,7):
				h1_list = []
				for h1 in soup.find_all('h'+str(i)):
					if h1.string:
						h1_list.append(h1.string)
				h1 = ' '.join([process_content(k) for k in h1_list])
				h.append(h1)

			# 处理strong
			strong_list = []
			for strong in soup.find_all('strong'):
				if strong.string:
					strong_list.append(strong.string)
			strong = ' '.join([process_content(k) for k in strong_list])

			# 处理页面内容
			p_list = []
			for p in soup.find_all('p'):
				if p.string:
					p_list.append(p.string)
			p = ' '.join([process_content(k) for k in p_list])

			print '\t\t<doc title='+title+' url='+filename[7:]+' pr='+str(pr)+'>'
			print '\t\t\t<docContent>'+p+'</docContent>'
			print '\t\t\t<anchor>'+anchor+'</anchor>'
			for i in range(1,7):
				print '\t\t\t<h'+str(i)+'>'+h[i]+'</h'+str(i)+'>'
			print '\t\t\t<strong>'+strong+'</strong>'
			print '\t\t</doc>'
		return 

def parse_pdf(filename, index):
	global xmlfile
	if (os.path.isfile(filename)):
		child = subprocess.Popen(['python2.exe', 'pdf2txt.py', filename], stdout=subprocess.PIPE)
		out = child.communicate()[0]
		xmlfile.write('\t\t<doc title=\"'+'PDF'+'\" url=\"'+filename[7:].decode('gbk')+'\" id=\"'+index+'\" pr=\"0.0\">\n')
		# print filename
		p = process_content(out)
		xmlfile.write('\t\t\t<docContent>'+p+'</docContent>\n')
		xmlfile.write('\t\t</doc>\n')
		pass

if __name__ == '__main__':
	# add_file('mirror/')
	# child1 = subprocess.Popen(["ls","-l"], stdout=subprocess.PIPE)
	# out = child1.communicate()[0]
	filter_suffix = ['doc', 'pdf', 'jsp', 'php', 'asp', 'aspx', 'docx', 'txt']
	f = open('node_id')
	file_dict = {}
	index_dict = {}
	# 只会parse一些html，在计算锚文本的时候仍然会考虑doc等文件
	for line in f:
		linearr = line.strip().split()
		if len(linearr) > 1:
			index = linearr[-1]
			if not index.isdigit():
				continue
			filename = ''
			for l in linearr[:-1]:
				filename += l
			file_dict[index] = filename
			index_dict[filename] = index

	xmlfile.write('<xml>\n')
	xmlfile.write('\t<urls>\n')
	# f2 = open('graph', 'w')
	# fpr = open('graph_result')
	# pr = {}
	# for line in fpr:
	# 	linearr = line.strip().split()
	# 	pr[linearr[0]] = linearr[1]

	# count = 0
	# perc = len(file_dict.keys())/1000+1
	for index in file_dict.keys():
		# if count%perc == 0:
		# 	print count/perc
		# count += 1
		filename = file_dict[index]
		temp = filename.split('.')
		if temp[-1] == 'pdf':
			print(filename)
			parse_pdf('mirror/'+filename, index)
			# print filename
	xmlfile.write('\t</urls>\n')
	xmlfile.write('</xml>\n')
	# parse_html('mirror/academic.tsinghua.edu.cn/index.html', str(1), index_dict, 0)
			
			