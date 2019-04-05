import jieba
import json
import operator

# doc_array = json.load(open("index.json", 'r', encoding="utf-8"))
# stopword = []
# with open("./stopword.txt", 'r', encoding="utf-8") as file:
#     for line in file:
#         stopword.append(line.strip())
# stopword = set(stopword)

# word_dict = {}
# print(len(doc_array))
# for i in range(len(doc_array)):
#     if i % 10 == 0:
#         print(i)
#     docContent = doc_array[i]['docContent']
#     if docContent != "":
#         cut_array = jieba.cut(docContent)
#         for word in cut_array:
#             if not word in stopword:
#                 if word in word_dict:
#                     word_dict[word] += 1
#                 else:
#                     word_dict[word] = 1
# sorted_word = sorted(word_dict.items(), key=operator.itemgetter(1))
# json.dump(sorted_word, open("tsinghua_wordtable.json", 'w', encoding="utf8"))


word_table = []
with open("./chinese_word table.txt", 'r', encoding='utf8') as file:
    for line in file:
        word = line.split('\t')[0]
        word_table.append(word)

with open("./english_word_table.txt", 'r', encoding='utf8') as file:
    for line in file:
        word_table.append(line.strip())

with open("spell.txt", 'w', encoding='utf8') as file:
    for word in word_table:
        file.write(word + "\n")