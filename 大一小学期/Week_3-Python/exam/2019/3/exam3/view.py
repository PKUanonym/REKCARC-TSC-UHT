# -*- coding: UTF-8 –*-
from django.shortcuts import HttpResponseRedirect,render
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse
from django.contrib import messages
import re

def initpage(request):
    return render(request, "login.html",{
            'a': "",
            'b' : "男",
            'c' : "2019-09-06",
            'd' : "",
            'data' : ""})


def login(request):
    out = ""
    user  = request.POST.get('name',None)
    sex = request.POST.get('sex',None)
    date = request.POST.get('date',None)
    email = request.POST.get('email',None)
    res = r"^[a-zA-Z0-9_](?:[a-zA-Z0-9_-]*[a-zA-Z0-9_])*@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])*(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])*)*$"
    yw = re.findall(res,email)
    print(yw)
    #print([user,sex,date,email])
    if (user and email and date and sex):
        if yw != []:
            #print([user,sex,date,email])
            f = open("3.txt",'a+',encoding='utf-8')
            f.write(user + "," + sex + "," + date + "," + email + "\n")
            f.close()
            user = ""
            sex = "男"
            date = "2019-09-06"
            email = ""
            out = "录入成功，请录入下一条信息"
        else:
            out = "邮箱格式不对"
    else:
        out = "表单项不能为空"


    return render(request,'login.html',{'data':out,'a':user,'b':sex,'c':date,'d':email})

def detail(request):
    f = open("3.txt",'r',encoding='utf-8')
    lines=f.readlines()
    f.close()
    aa = []
    for line in lines:
        ll = line.strip("\n").split(",")
        aa.append({"name":ll[0],"sex":ll[1],"date":ll[2],"email":ll[3]})
    #print(aa)
    return render(request,'detail.html',{'data':aa})