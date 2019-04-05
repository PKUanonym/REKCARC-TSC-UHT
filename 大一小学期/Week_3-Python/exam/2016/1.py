import os,sys

case=0 # 1: size, 2: file, 3: key
lim=0
str=""
word=[]

def check(f):
    global case,lim,str,word
    if case==1:
        return os.path.getsize(f)>lim
    elif case==2:
        return f.split('.')[-1]==str
    elif case==3:
        with open(f,"r") as fin:
            s=fin.read()
        flag=1
        for w in word:
            if s.find(w)==-1:
                flag=0
        return flag

def dfs(dir):
    for f in os.listdir(dir):
        path=os.path.join(dir,f)
        if os.path.isdir(path):
            dfs(path)
        else:
            if check(path):
                print(path)

try:
    if sys.argv[1]=="size":
        case=1
        lim=int(sys.argv[2])
    elif sys.argv[1]=="file":
        case=2
        str=sys.argv[2]
    elif sys.argv[1]=="key":
        case=3
        for i in range(len(sys.argv)):
            if i>1:
                word.append(sys.argv[i])
        #print(word)
    dfs("docs")
except:
    print("Using command: python size/file/key ...")

