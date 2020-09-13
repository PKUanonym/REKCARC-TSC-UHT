import re
full_line = ""
with open('COVID19_US.html', 'r') as f:
    lines = f.readlines()
    for line in lines:
        full_line += line.strip("\n").replace("\t", "")
    res = re.findall(
        r'<th><a href=\"(https://en.wikipedia.org/wiki/COVID-19_.*?)\"title="COVID-19 pandemic in .*?\"><abbr.?title=\"(.*?)\">(.*?)</abbr></a></th>', full_line)
with open('states.txt', 'w') as f:
    for a, b, c in res:
        print("%s,%s,%s" % (c, b, a), file=f)

