from django.shortcuts import render
from django.core.paginator import Paginator
from django.shortcuts import render,redirect,reverse
from django.http import HttpResponseRedirect
from .forms import checkForm1
from . import models
from django.db.models import Max
import ast
# Create your views here.

def form1(request):
    if request.method == 'POST':
        form = checkForm1(request.POST)
        if not form.is_valid():
            context = {}
            context['form'] = checkForm1()
            return render(request, 'form/form1.html', context)
        area = []
        with open('full_count_ps.txt', 'r') as f:
            lines = f.readlines()
            area_num = ast.literal_eval(lines[0])
        with open('distrib.txt', 'r') as f:
            lines = f.readlines()
            for line in lines:
                area.append(line.split(",")[0])
        input_area = form.cleaned_data.get("area")
        for i in range(len(area)):
            if(area[i]==input_area):
                context = {}
                context['form'] = checkForm1()
                context['posts'] = area_num[i][:5]
                return render(request, 'form/form1.html', context)
        context = {}
        context['form'] = checkForm1()
        context['msg'] = "地区无效！"
        return render(request, 'form/form1.html', context)
    else:
        context = {}
        context['form'] = checkForm1()
        return render(request, 'form/form1.html', context)


# def form2(request):
#     if request.method == 'POST':
#         form = checkForm2(request.POST)
#         if not form.is_valid():
#             context = {}
#             context['form'] = checkForm2()
#             return render(request, 'form/form1.html', context)
#         # area = []
#         # with open('full_count_ps.txt', 'r') as f:
#         #     lines = f.readlines()
#         #     area_num = ast.literal_eval(lines[0])
#         # with open('distrib.txt', 'r') as f:
#         #     lines = f.readlines()
#         #     for line in lines:
#         #         area.append(line.split(",")[0])
#         # input_area = form.cleaned_data.get("area")
#         # for i in range(len(area)):
#         #     if (area[i] == input_area):
#         #         context = {}
#         #         context['form'] = checkForm1()
#         #         context['posts'] = area_num[i][:5]
#         #         return render(request, 'form/form1.html', context)
#         context = {}
#         context['form'] = checkForm2()
#         context['msg'] = "地区无效！"
#         return render(request, 'form/form1.html', context)
#     else:
#         context = {}
#         context['form'] = checkForm2()
#         return render(request, 'form/form1.html', context)