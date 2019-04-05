from bs4 import BeautifulSoup as bs

def get(s):
    if s.find(',')!=-1:
        s=s[:s.find(',')]
    if s.find('(')!=-1:
        s=s[:s.find('(')]
    if s.find('-')!=-1:
        s=s[:s.find('-')]
    s=' '.join(s.split())
    return s

name1=[]
name2=[]
name3=[]
name4=[]

with open("2/csrank1.html","r") as f:
    soup=bs(f.read(),"html.parser")
cnt=0
str1=0
str2=""
for i in soup.find_all(class_="s1"):
    if i.get_text():
        cnt+=1
        if cnt%4==1 and cnt>4:
            str1=int(i.get_text())
        elif cnt%4==2 and cnt>4:
            str2=i.get_text().replace('\xa0','')
            str2=get(str2)
            name1.append([str1,str2])
print()
print(name1)
len1=len(name1)

with open("2/csrank2.html","r") as f:
    soup=bs(f.read(),"html.parser")

for i in soup.find_all(class_="s3"):
    str2=i.get_text()
    if i.parent.previousSibling.previousSibling.getText()=="Tie":
        str1=int(i.parent.previousSibling.previousSibling.previousSibling.previousSibling.get_text()[1:])
    else:
        str1=int(i.parent.previousSibling.previousSibling.getText()[1:])
    str2=get(str2)
    name2.append([str1,str2])
print()
print(name2)

with open("2/csrank3.html","r") as f:
    soup=bs(f.read(),"html.parser")

for i in soup.find_all('td',class_='left'):
    str2=i.get_text()
    str=i.previousSibling.getText().replace('-','+')
    if str.find("+")==-1:
        str1=int(str)
    else:
        str1=eval(str)/2.
    str2=get(str2)
    name3.append([str1,str2])

print()
print(name3)

with open("2/csrank4.html","r") as f:
    soup=bs(f.read(),"html.parser")

cnt=0
for i in soup.find_all('a'):
    cnt+=1
    if cnt>=23 and cnt<=524:
        str2=i.get_text()
        tmp=i
        for j in range(12):
            tmp=tmp.parent
        str=' '.join(tmp.get_text().split())
        str=str.split()[0].replace('-','+').replace('=','')
        if str.find('+')==-1:
            str1=int(str)
        else:
            str1=eval(str)/2.
        str2=get(str2)
        name4.append([str1,str2])

print()
print(name4)

len1=len(name1)
len2=len(name2)
len3=len(name3)
len4=len(name4)

name=[]
for i in name1:
    name.append([i[1],i[0],1])
for i in name2:
    name.append([i[1],i[0],2])
for i in name3:
    name.append([i[1],i[0],3])
for i in name4:
    name.append([i[1],i[0],4])
name.sort()
print()
for i in name:
    print(i[0])

rank=[]
lst=set()
for i in name:
    if i[0] not in lst:
        lst.add(i[0])
        flag=0
        for j in name1:
            if j[1]==i[0]:
                flag=1
                rk1=j[0]
        if flag==0:
            rk1=len1+1
        flag=0
        for j in name2:
            if j[1]==i[0]:
                flag=1
                rk2=j[0]
        if flag==0:
            rk2=len2+1
        flag=0
        for j in name3:
            if j[1]==i[0]:
                flag=1
                rk3=j[0]
        if flag==0:
            rk3=len3+1
        flag=0
        for j in name4:
            if j[1]==i[0]:
                flag=1
                rk4=j[0]
        if flag==0:
            rk4=len4+1 
        rank.append([(rk1+rk2+rk3+rk4)/4.,i[0]])

rank.sort()
with open("rklist.txt","w") as f:
    for i in rank:
        f.write("%d: %s\n"%(i[0],i[1]))
