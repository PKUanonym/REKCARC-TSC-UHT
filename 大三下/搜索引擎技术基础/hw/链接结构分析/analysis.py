import pickle as pkl
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats.stats import pearsonr

pr = pkl.load(open("pr.pkl", 'rb'))
index2entry = pkl.load(open("index2entry.pkl", 'rb'))

pr = np.array(pr)

# arg_index = pr.argsort()

# for i in range(10):
#     index = arg_index[i]
#     print(pr[index])
#     print(index2entry[index])
# print()

# for i in range(10):
#     index = arg_index[len(pr) - 1 - i]
#     print(pr[index])
#     print(index2entry[index])
# out_link = pkl.load(open("out_link.pkl", 'rb'))
# normalized_out = []
in_link = pkl.load(open("in_link.pkl", 'rb'))
print(pearsonr(pr, in_link))
# for i in range(len(in_link)):
#     if(in_link[i] != 0):
#         normalized_out.append(in_link[i])
# bins = np.linspace(0, 0.01, 100)
# plt.xscale('log')
# plt.yscale('log')
# plt.hist(pr, bins)
# plt.show()

# plt.scatter(in_link, pr)
# plt.show()