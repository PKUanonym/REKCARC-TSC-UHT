#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import string

from html_table_parser import HTMLTableParser


if __name__ == '__main__':
    with open('origin.html', 'r', encoding='utf-8') as f:
        text = f.read()

    p = HTMLTableParser()
    p.feed(text)

    # task 1
    tables = p.tables
    for table in tables:
        letter = table['letter']
        rows = table['table']
        data = '\n'.join([','.join(row) for row in rows])
        with open('csv/%s.csv' % letter, 'w', encoding='utf-8') as f:
            f.write(data)

    # task 2
    ns = '</tbody>\n\t\t\t</table>\n\t\t\t<h3>{}</h3>\n\t\t\t<table border="0" cellpadding="1" cellspacing="1" width="90%" align="center">\n\t\t\t\t<tbody>\n\t\t\t\t\t<tr bgcolor="#99CCFF">\n\t\t\t\t\t\t<th width="25%">国家或地区 </th>\n\t\t\t\t\t\t<th width="27%">中文全称 </th>\n\t\t\t\t\t\t<th width="26%">英文简称 </th>\n\t\t\t\t\t\t<th width="26%">ISO代码 </th>\n\t\t\t\t\t</tr>'

    for s in string.ascii_uppercase[1:]:
        text = text.replace(ns.format(s), '')

    with open('all.html', 'w', encoding='utf-8') as f:
        f.write(text)

    # task 3
    text = text.replace('<h3>A</h3>', '<h3>#</h3>')
    text = ''.join(text.split('\n'))
    text = re.sub(r'<tr bgcolor="#99FF99">.*?</tr>', '',
                  text, flags=re.S)  # remove color lines
    text = re.sub(r'<span class="flagicon">.*?</span>', '',
                  text, flags=re.S)  # remove img under span
    text = re.sub(r'<img.*?>', '', text, flags=re.S)  # remove seperate img
    text = re.sub(r'<a.*?>(.*?)</a>', r'\g<1>', text, flags=re.S)  # remove a
    with open('color.html', 'w', encoding='utf-8') as f:
        f.write(text)
