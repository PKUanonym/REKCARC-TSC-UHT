import re
full_line = ""
area = []
date = []
with open('states.txt', 'r') as f:
    lines = f.readlines()
    for line in lines:
        area.append(line.split(",")[0])

cal = [0] * len(area)
with open('COVID19_US.html', 'r') as f:
    lines = f.readlines()
    for line in lines:
        full_line += line.strip("\n").replace("\t", "")
    res = re.findall(
        r'<tr><th><abbr title=".*?, 2020">(.*?)</abbr></th>(.*?)</tr>', full_line)
    mix = 0
    for i in res:
        today = 0
        num = re.findall(r'<td>(.*?)</td>', i[1])
        for j in range(len(num)):
            if num[j]:
                cal[j] += int(num[j])
                today += int(num[j])
        mix += today
        date.append([i[0],today,mix])
with open('distrib.txt', 'w') as f:
    for i in range(len(area)):
        print("%s,%s" % (area[i], cal[i]), file=f)
with open('trend.txt', 'w') as f:
    for a, b, c in date:
        print("%s,%s,%s" % (a, b, c), file=f)