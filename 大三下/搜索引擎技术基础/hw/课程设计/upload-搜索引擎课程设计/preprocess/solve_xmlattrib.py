import xml.etree.cElementTree as ET
import json

doc_array = []
with open("index_word.xml", 'r', encoding="utf8") as file:
    counter = 0
    file.readline()
    file.readline()
    currentNode = {}
    for line in file:
        if counter % 3 == 0:
            line = line.strip()
            try:
                filtered_line, index = line.split(" id=", 1)
            except Exception:
                break
            title, url = filtered_line.split(" url=", 1)
            title = title.split(" title=\"", 1)[1][:-1]
            url = url[1:-1]
            index = index.split("\" pr=", 1)[0][1:]
            currentNode['title'] = title
            currentNode['url'] = url
            currentNode['id'] = index
        elif counter % 3 == 1:
            line = line.strip()
            line = line.replace("<docContent>", "", 1)
            line = line.replace("</docContent>", "", 1)
            currentNode['docContent'] = line
        else:
            doc_array.append(currentNode)
            currentNode = {}
        counter += 1

with open("index_pdf.xml", 'r', encoding="utf8") as file:
    counter = 0
    file.readline()
    file.readline()
    currentNode = {}
    for line in file:
        if counter % 3 == 0:
            line = line.strip()
            try:
                filtered_line, index = line.split(" id=", 1)
            except Exception:
                break
            title, url = filtered_line.split(" url=", 1)
            title = title.split(" title=\"", 1)[1][:-1]
            url = url[1:-1]
            index = index.split("\" pr=", 1)[0][1:]
            currentNode['title'] = title
            currentNode['url'] = url
            currentNode['id'] = index
        elif counter % 3 == 1:
            line = line.strip()
            line = line.replace("<docContent>", "", 1)
            line = line.replace("</docContent>", "", 1)
            currentNode['docContent'] = line
        else:
            doc_array.append(currentNode)
            currentNode = {}
        counter += 1

with open("index.xml", 'r', encoding="utf8") as file:
    counter = 0
    file.readline()
    file.readline()
    currentNode = {}
    for line in file:
        if counter % 11 == 0:
            line = line.strip()
            try:
                filtered_line, index = line.split(" id=", 1)
            except Exception:
                break
            title, url = filtered_line.split(" url=", 1)
            title = title.split(" title=\"", 1)[1][:-1]
            url = url[1:-1]
            index = index.split("\" pr=", 1)[0][1:]
            currentNode['title'] = title
            currentNode['url'] = url
            currentNode['id'] = index
        elif counter % 11 == 1:
            line = line.strip()
            line = line.replace("<docContent>", "", 1)
            line = line.replace("</docContent>", "", 1)
            currentNode['docContent'] = line
        elif counter % 11 == 2:
            line = line.strip()
            line = line.replace("<anchor>", "", 1)
            line = line.replace("</anchor>", "", 1)
            currentNode['anchor'] = line
        elif counter % 11 == 3:
            line = line.strip()
            line = line.replace("<h1>", "", 1)
            line = line.replace("</h1>", "", 1)
            currentNode['h1'] = line
        elif counter % 11 == 4:
            line = line.strip()
            line = line.replace("<h2>", "", 1)
            line = line.replace("</h2>", "", 1)
            currentNode['h2'] = line
        elif counter % 11 == 5:
            line = line.strip()
            line = line.replace("<h3>", "", 1)
            line = line.replace("</h3>", "", 1)
            currentNode['h3'] = line
        elif counter % 11 == 6:
            line = line.strip()
            line = line.replace("<h4>", "", 1)
            line = line.replace("</h4>", "", 1)
            currentNode['h4'] = line
        elif counter % 11 == 7:
            line = line.strip()
            line = line.replace("<h5>", "", 1)
            line = line.replace("</h5>", "", 1)
            currentNode['h5'] = line
        elif counter % 11 == 8:
            line = line.strip()
            line = line.replace("<h6>", "", 1)
            line = line.replace("</h6>", "", 1)
            currentNode['h6'] = line
        elif counter % 11 == 9:
            line = line.strip()
            line = line.replace("<strong>", "", 1)
            line = line.replace("</strong>", "", 1)
            currentNode['strong'] = line
        elif counter % 11 == 10:    
            doc_array.append(currentNode)
            currentNode = {}
        counter += 1
        if counter % 10000 == 0:
            print(counter)

json.dump(doc_array, open("index.json", 'w', encoding="utf8"))