import os,sys

case=0 # 1: FL, 2: FG, 3: SL 4: SG 5: DL 6: DG
lim=0

def check(f):
    global case,lim
    if case==1:
        return len(f.split(os.sep)[-1])<lim and os.path.isfile(f)
    elif case==2:
        return len(f.split(os.sep)[-1])>lim and os.path.isfile(f)
    elif case==3:
        return os.path.getsize(f)<lim and os.path.isfile(f)
    elif case==4:
        return os.path.getsize(f)>lim and os.path.isfile(f)
    else:
        return False

def dfs(dir):
    global case,lim
#    print(dir)
    sum=0
    for f in os.listdir(dir):
        path=os.path.join(dir,f)
        if os.path.isdir(path):
            sum+=dfs(path)
        elif os.path.isfile(path):
            if check(path):
                print(path)
            sum+=os.path.getsize(path)
    if case==5 and sum<lim and os.path.isdir(dir):
        print(dir)
    elif case==6 and sum>lim and os.path.isdir(dir):
        print(dir)
    return sum

try:
#if 1:
    if sys.argv[1]=="FL":
        case=1
        lim=int(sys.argv[2])
    elif sys.argv[1]=="FG":
        case=2
        lim=int(sys.argv[2])
    elif sys.argv[1]=="SL":
        case=3
        lim=float(sys.argv[2])
    elif sys.argv[1]=="SG":
        case=4
        lim=float(sys.argv[2])
    elif sys.argv[1]=="DL":
        case=5
        lim=float(sys.argv[2])
    elif sys.argv[1]=="DG":
        case=6
        lim=float(sys.argv[2])
    dfs("1")
#    print(os.sep)
except:
    print("Using command: python FL/FG/SL/SG/DL/DG number")

