#coding:utf8
import xml.etree.cElementTree as ET


def solve_child(child):
    new_root = ET.Element('doc')
    new_root.set('id', child.attrib['id'])
    new_root.set('pr', child.attrib['pr'])
    if (child.attrib['title'] != None):
        new_root.set('title', child.attrib['title'])
    new_root.set('url', child.attrib['url'])
    for grandson in child:
        if grandson.text != None:
            new_root.set(grandson.tag, grandson.text)
    return new_root

word_tree = ET.ElementTree(file='index_word.xml')
pdf_tree = ET.ElementTree(file='index_pdf_process.xml')
html_tree = ET.ElementTree(file='index.xml')


# deal with html
html_root = html_tree.getroot()
html_url_root = html_root[0]

word_root = word_tree.getroot()
word_url_root = word_root[0]

pdf_root = pdf_tree.getroot()
pdf_url_root = pdf_root[0]

merge_root = ET.Element('xml')
url_root = ET.SubElement(merge_root, 'urls')
for child in html_url_root:
    url_root.append(solve_child(child))

for child in word_url_root:
    url_root.append(solve_child(child))

for child in pdf_url_root:
    url_root.append(solve_child(child))

merge_tree = ET.ElementTree(merge_root)
merge_tree.write("index_merge.xml", "utf-8")