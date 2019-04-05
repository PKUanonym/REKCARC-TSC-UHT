import os
import re
import shutil
from collections import defaultdict

sma = re.compile(r'.*[.][Ss]$')
chpma = re.compile(r'Chapter(.*?)\\')
counter = defaultdict(int)

for dirName, subdirList, fileList in os.walk("."):
    for fname in fileList:
        if sma.match(fname) != None:
            print fname
            abspath = dirName + '\\' + fname
            dst_name = chpma.findall(abspath)[0]
            counter[dst_name] += 1
            dst_name = dst_name + "_" + str(counter[dst_name]) + ".s"
            print abspath
            print "==="
            shutil.copyfile(abspath, "./tests/" + dst_name)