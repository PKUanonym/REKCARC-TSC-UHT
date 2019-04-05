#coding:utf8
# parse graph and xml, then generate pr, write xml
import json

alpha = 0.15
TN = 50
node_num = 287129
adj_list = []

for i in range(node_num):
    adj_list.append([])

with open("graph", 'r') as file:
    for line in file:
        line = line.strip()
        head, node = line.split(':')
        head = int(head)
        node_array = node.split(',')
        if(node_array[0] == ''):
            continue
        for node in node_array:
            adj_list[head].append(int(node))
        adj_list[head] = list(set(adj_list[head]))

# adj build finished
init_pr = float(1) / len(adj_list)
pr = [0] * len(adj_list)
tmp = [0] * len(adj_list)

# init
for i in range(len(pr)):
    pr[i] = init_pr
    tmp[i] = init_pr * alpha

print("start page rank")
for k in range(TN):
    zero_degree_sum = 0
    for i in range(len(adj_list)):
        current_list = adj_list[i]
        if(len(current_list) == 0):
            zero_degree_sum += ((1 - alpha) * pr[i] / len(adj_list))
        else:
            tmp_score = (1 - alpha) * pr[i] / len(current_list)
            for j in range(len(current_list)):
                tmp_index = current_list[j]
                tmp[tmp_index] += tmp_score
    for i in range(len(pr)):
        pr[i] = zero_degree_sum + tmp[i]
        tmp[i] = init_pr * alpha
    print(k)

index_tree = json.load(open('index.json', encoding="utf-8"))
for child in index_tree:
    index = int(child['id'])
    child_pr = pr[index]
    child['pr'] = str(child_pr)

json.dump(index_tree, open("index.json", 'w', encoding='utf-8'))