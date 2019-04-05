import os
import sys

def TestSize(rootDir):
    global lim
    for lists in os.listdir(rootDir):
        path = os.path.join(rootDir, lists)
        if os.path.isdir(path):
            TestSize(path)
        elif os.path.getsize(path) > lim:
            print path, os.path.getsize(path)

def TestType(rootDir):
    global req
    for lists in os.listdir(rootDir):
        path = os.path.join(rootDir, lists)
        if os.path.isdir(path):
            TestType(path)
        elif path.split('.')[-1] == req:
            print path

def TestList(rootDir):
    global word_list
    for lists in os.listdir(rootDir):
        path = os.path.join(rootDir, lists)
        if os.path.isdir(path):
            TestList(path)
        else:
            data = file(path, 'r').read()
            ok = True
            for word in word_list:
                if data.find(word) == -1:
                    ok = False
                    break
            if ok:
                print path

lim = 0
req = ''
word_list = []
if sys.argv[1] == 'size':
    lim = int(sys.argv[2])
    TestSize("docs")
elif sys.argv[1] == 'file':
    req = sys.argv[2]
    TestType("docs")
elif sys.argv[1] == 'key':
    for i in range(2, len(sys.argv)):
        word_list.append(sys.argv[i])
    TestList("docs")