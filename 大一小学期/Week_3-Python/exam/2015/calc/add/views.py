from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

token=r'{% csrf_token %}'
calculator='''
<form method="post" action="/">
    %s
    <input type="text" name="input" value="%s">
    <table>
    <tr>
        <td><input type="submit" value="1" name="b"></td>
        <td><input type="submit" value="2" name="b"></td>
        <td><input type="submit" value="3" name="b"></td>
        <td></td>
        <td><input type="submit" value="+" name="b"></td>
        <td><input type="submit" value="-" name="b"></td>
    </tr>
    <tr>
        <td><input type="submit" value="4" name="b"></td>
        <td><input type="submit" value="5" name="b"></td>
        <td><input type="submit" value="6" name="b"></td>
        <td></td>
        <td><input type="submit" value="*" name="b"></td>
        <td><input type="submit" value="/" name="b"></td>
    </tr>
    <tr>
        <td><input type="submit" value="7" name="b"></td>
        <td><input type="submit" value="8" name="b"></td>
        <td><input type="submit" value="9" name="b"></td>
        <td></td>
        <td><input type="submit" value="=" name="b"></td>
        <td><input type="submit" value="C" name="b"></td>
    </tr>
    <tr>
        <td></td>
        <td><input type="submit" value="0" name="b"></td>
    </tr>
    </table>
</form>
'''
text=""
text2=""

def wr(s):
    with open("try.html","w") as f:
        f.write(calculator%(token,s))

def calc(request):
    global text,text2
    print(request.POST)
    try:
        c=request.POST['b']
    except:
        c='n'
    print(c)
    if c=='C' or c=='n':
        text=""
        text2=""
    elif c=='=':
        text="%f"%eval(text2)
    elif c=='+' or c=='-' or c=='*' or c=='/':
        text+=c
        text2+='.0'+c
    else:
        text+=c
        text2+=c
    print(text,text2)
    try:
        print(eval(text2))
    except:
        print("qwq")
    wr(text)
    return render(request,"try.html") #HttpResponse(calculator%(0))
    #if request.POST.has_key('input'):

