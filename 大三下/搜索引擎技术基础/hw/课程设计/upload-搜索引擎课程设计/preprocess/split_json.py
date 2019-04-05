import json

doc_array = json.load(open("index.json", 'r', encoding="utf-8"))
counter = 0
fileindex = 0
tmp_doc_array = []
for doc in doc_array:
    tmp_doc_array.append(doc)
    counter += 1
    if counter % 10000 == 0:
        json.dump(tmp_doc_array, open("./index/index" + str(fileindex) + ".json", 'w'))
        tmp_doc_array = []
        fileindex += 1
json.dump(tmp_doc_array, open("./index/index" + str(fileindex) + ".json", 'w'))