import re
full_line = ""
area = []
date = []
with open('states.txt', 'r') as f:
	lines = f.readlines()
	for line in lines:
		area.append(line.split(",")[0])

area_num = [[] for _ in range(len(area))]
with open('COVID19_US.html', 'r') as f:
	lines = f.readlines()
	for line in lines:
		full_line += line.strip("\n").replace("\t", "")
	res = re.findall(
		r'<tr><th><abbr title=".*?, 2020">(.*?)</abbr></th>(.*?)</tr>', full_line)
	for i in res:
		num = re.findall(r'<td>(.*?)</td>', i[1])
		for j in range(len(num)):
			if num[j]:
				area_num[j].append([i[0],int(num[j])])
			else:
				area_num[j].append([i[0],0])
with open('full_count.txt', 'w') as f:
	print(area_num,file=f)
def takeSecond(elem):
	return elem[1]
for i in range(len(area_num)):
	area_num[i] = sorted(area_num[i],key=takeSecond,reverse=True)
with open('full_count_ps.txt', 'w') as f:
	print(area_num,file=f)