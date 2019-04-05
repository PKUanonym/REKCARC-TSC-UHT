# 首先建立id 和 index的映射，index和中文的映射
# 初始化邻接链表
# 随后build整个graph
import pickle as pkl
counter = 0
id2index = {}
index2entry = {}
adj_list = []
with open("node.map.utf8", 'r', encoding="utf-8") as file:
    for line in file:
        line = line.strip()
        entry, id = line.split("-->")
        id = int(id)
        id2index[id] = counter
        index2entry[counter] = entry
        counter += 1

print("index build finished")

for i in range(len(id2index)):
    adj_list.append([])

with open("wiki.graph", 'r') as file:
    for line in file:
        line = line.strip()
        head, node = line.split(':')
        head = int(head)
        head_index = id2index[head]
        node_array = node.split(',')
        if(node_array[0] == ''):
            continue
        for node in node_array:
            node_index = id2index[int(node)]
            adj_list[head_index].append(node_index)

print("graph build finished")
pkl.dump(index2entry, open("index2entry.pkl", 'wb'))
pkl.dump(adj_list, open("adj.pkl", 'wb'))