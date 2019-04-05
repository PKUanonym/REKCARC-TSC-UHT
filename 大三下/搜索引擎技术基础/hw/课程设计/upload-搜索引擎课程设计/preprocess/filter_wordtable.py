import json
import re


word_table = json.load(open("./tsinghua_wordtable.json", encoding="utf8"))
xx = u"([\u4e00-\u9fff]+)"
pattern = re.compile(xx)
print(len(word_table))
result_word = []

for item in word_table:
    if item[1] > 50:
        result_word.append(item[0])

file = open("filter_table.txt", 'w', encoding="utf8")
counter = 0
for word in result_word:
    tmpstr = pattern.match(word)
    if tmpstr != None and tmpstr.group() == word and len(word) >= 2:
        file.write(word + "\n")
        counter += 1
print(counter)