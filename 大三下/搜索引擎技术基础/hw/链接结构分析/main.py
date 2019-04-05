import pickle as pkl
alpha = 0.15
TN = 20

adj_list = pkl.load(open("adj.pkl", 'rb'))
index2entry = pkl.load(open("index2entry.pkl", 'rb'))

init_pr = 1 / len(adj_list)
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

pkl.dump(pr, open("pr.pkl", 'wb'))