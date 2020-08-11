# python3
from fractions import Fraction
import sys
order1 = ["S","H","C","D"]
order2 = ["2","A","K","Q","J","10","9","8","7","6","5","4","3"]
order2.reverse()
order = []
for i in order2:
    for j in order1:
        order.append(j+i)
num_list = [False] * 52
ERR4 = False

def err(num):
    print("Error" + str(num))
    exit()
def mysort(str):
    cards = str.split(",")
    tmp = []
    for card in cards:
        if not order.__contains__(card):
            err(3)
        index = order.index(card)
        #print(index)
        tmp.append(index)
        if num_list[index]:
            global ERR4
            ERR4 = True
        else:
            num_list[index] = True
    tmp.sort()
    return [[order[x] for x in tmp], [int(x / 4) for x in tmp]]
def check(list):
    if (len(list) == 1):
        return [1,list[0]]
    elif len(list)==4:
        if list[1] != list[2]:
            return [0,0]
        cnt = 0
        if list[0] == list[1]:
            cnt = cnt + 1
        if list[2] == list[3]:
            cnt = cnt + 1
        if cnt == 0:
            return [0,1]
        return [cnt+2,list[1]]
    elif len(list)>=5:
        if (list[-1]>=12):
            return [0,-2]
        for i in range(0,len(list)-1):
            if (list[i+1] != list[i] + 1):
                return [0,i+2]
        return [2,list[-1]]
    else:
        return [0,-1]

def cmp(check1, check2):
    if check1[1] > check2[1]:
        print(">")
    elif check1[1] < check2[1]:
        print("<")
    else:
        print("=")

if len(sys.argv) < 2:
    err(1)

mode = sys.argv[1]

if (mode == "-sort"):
    if (len(sys.argv) != 3):
        err(2)
    list = mysort(sys.argv[2])[0]
    if (ERR4):
        err(4)
    print (','.join(list))
elif mode == "-check":
    if (len(sys.argv) != 3):
        err(2)
    list = mysort(sys.argv[2])[1]
    if (ERR4):
        err(4)
    print(check(list)[0])
elif mode == "-cmp":
    if (len(sys.argv) != 4):
        err(2)
    list1 = mysort(sys.argv[2])[1]
    list2 = mysort(sys.argv[3])[1]
    if (ERR4):
        err(4)
    check1 = check(list1)
    check2 = check(list2)
    if check1[0] == 0 or check2[0] == 0:
        print("=");exit()
    elif check1[0] == 4 or check2[0] == 4:
        if check2[0] != 4:
            print(">");exit()
        elif check1[0] != 4:
            print("<");exit()
        else:
            cmp(check1, check2);exit()
    else:
        if check1[0] != check2[0]:
            print("=");exit()
        else:
            cmp(check1,check2);exit()
    pass
else:
    err(1)