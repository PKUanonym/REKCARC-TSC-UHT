#coding=utf-8
import sys  
reload(sys)  
sys.setdefaultencoding('utf8')
from bs4 import BeautifulSoup
import os
import chardet
from xml.sax.saxutils import escape
def generate_index():
	pass

xmlfile = open('index.xml', 'w')
# web_count = 0
# f = open('node_id', 'w')
def add_file(root_dir):
	# global web_count
	# global f
	for lists in os.listdir(root_dir):
		path = os.path.join(root_dir, lists)
		path = path.replace("\\", '/')
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
	# no 404 preprocessing
	if (os.path.isfile(filename)):
		file = open(filename)
		content = file.read()
		print(filename)
		print(chardet.detect(content))
		soup = BeautifulSoup(content, 'html5lib')
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
			f.write(str(index) + "\n")
			if len(link_list) > 0:
				f.write(index+':'+','.join(link_list)+'\n')
		return 

def parse_html(filename, index, index_dict, pr):
	global xmlfile
	# no 404 preprocessing
	f = open('graph', 'a')
	if (os.path.isfile(filename)):
		file = open(filename)
		content = file.read()
		encoding = chardet.detect(content)['encoding'].lower()
		try:
			content = content.decode(encoding)
		except Exception:
			return
		soup = BeautifulSoup(content, 'html5lib', from_encoding=encoding)
		if soup.title:
			# print soup.title.text
			title = process_content(soup.title.text)
		else:
			title = ""
		# 处理超链接， 获取锚文本
		anchor_list = []
		# 生成链接
		link_list = []
		for a in soup.find_all('a'):
			a_str = a.getText()
			if 'href' in a.attrs and a_str != None:
				# print(a_str, a.attrs['href'])
				# print a.attrs['href'], a.string
				href = a.attrs['href']

				if href[0:7] == 'http://':
					href = href[7:]
				else:
					parent_url = filename[7:].rsplit('/', 1)[0]
					# print(filename, parent_url, href)
					href = parent_url + "/" + href
				# 锚文本
				anchor_list.append(a_str)
				if (index == 198):
					print href
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
				h1_str = h1.getText().strip()
				if h1_str != "":
					h1_list.append(h1_str)
			h1 = ' '.join([process_content(k) for k in h1_list])
			h.append(h1)

		# 处理strong
		strong_list = []
		for strong in soup.find_all('strong'):
			strong_str = strong.getText().strip()
			if strong_str != "":
				strong_list.append(strong_str)
		strong = ' '.join([process_content(k) for k in strong_list])

		# 处理页面内容
		p_list = []
		for p in soup.find_all('p'):
			p_str = p.getText().strip()
			if p_str != "":
				p_list.append(p_str)
		p = ' '.join([process_content(k) for k in p_list])
		xmlfile.write('\t\t<doc title=\"'+title+'\" url=\"'+filename[7:]+'\" id=\"'+index+'\" pr=\"'+str(pr)+'\">\n')
		xmlfile.write('\t\t\t<docContent>'+p+'</docContent>\n')
		xmlfile.write('\t\t\t<anchor>'+anchor+'</anchor>\n')
		for i in range(1,7):
			xmlfile.write('\t\t\t<h'+str(i)+'>'+h[i]+'</h'+str(i)+'>\n')
		xmlfile.write('\t\t\t<strong>'+strong+'</strong>\n')
		xmlfile.write('\t\t</doc>\n')
	return 

if __name__ == '__main__':
	# add_file('mirror/')
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
	# # f2 = open('graph', 'w')
	# fpr = open('graph_result')
	# pr = {}
	# for line in fpr:
	# 	linearr = line.strip().split()
	# 	pr[linearr[0]] = linearr[1]

	count = 0
	perc = len(file_dict.keys())/1000+1
	for index in file_dict.keys():
		# if count%perc == 0:
		# 	print count/perc
		count += 1
		print(count)
		filename = file_dict[index]
		temp = filename.split('.')
		if temp[-1] == 'html' or temp[-1] == 'htm':
			# if index not in pr:
			# 	pr[index] = 0
			# parse_html('mirror/'+filename, index, index_dict, pr[index])
			parse_html('mirror/'+filename, index, index_dict, 0)
	xmlfile.write('\t</urls>\n')
	xmlfile.write('</xml>\n')