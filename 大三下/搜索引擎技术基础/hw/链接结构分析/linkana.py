import pickle as pkl

adj_list = pkl.load(open("adj.pkl", 'rb'))
out_link = [0] * len(adj_list)
in_link = [0] * len(adj_list)

for i in range(len(adj_list)):
    out_link[i] = len(adj_list[i])
    for j in range(len(adj_list[i])):
        in_link[adj_list[i][j]] += 1

pkl.dump(out_link, open("out_link.pkl", 'wb'))
pkl.dump(in_link, open("in_link.pkl", 'wb'))