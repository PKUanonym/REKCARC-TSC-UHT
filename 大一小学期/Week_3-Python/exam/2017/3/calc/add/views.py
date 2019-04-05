from django.shortcuts import render
from django.http import HttpResponse
import os
# Create your views here.

token=r'{% csrf_token %}'
html='''
<html>
<center>
    <form method="post" action="/">
        %s
        <table>
        <tr><td>n: </td><td><input type="number" name="n" value=""></td></tr>
        <tr><td>m: </td><td><input type="number" name="m" value=""></td></tr>
        <tr><td><input type="submit" value="calc" name="calc"></td></tr>
        </table>
    </form>
    <table>
        <tr><td>d0 = %d</td></tr>
        <tr><td>gx = %d</td></tr>
        <tr><td>gy = %d</td></tr>
        <tr><td>Total Length: %d</td></tr>
        <tr><td>CPU Time: %f</td></tr>
        <tr><td>Output Result: <a href="path.txt">Routing Result</a></td></tr>
        <tr><td>Output Image: <img src="image.png"></td></tr>
    </table>
    %s
</center>
</html>
'''

def write(d0=0, gx=0, gy=0, tl=0, time=0, msg=''):
    with open("try.html", "w") as f:
        f.write(html % (token, d0, gx, gy, tl, time, msg))

def calc(request):
    try:
        tmp = int(request.POST['n'])
        ispost = 1
    except:
        ispost = 0
    if not ispost: # initial
        write()
    else: # calc
        n = int(request.POST['n'])
        m = int(request.POST['m'])
        print(n, m)
        if 0 < n <= 1000 and 0 < m <= 1000:
            # run the program
            os.system('time ./main -x %d -y %d --no-window -o image.png -p path.txt >> log.txt 2>&1' % (n, m))
            info = open('log.txt').read()
            # calc gx, gy
            gxy_info = info.split('Found grid size: ')[-1].split('\n')[0]
            gx = int(gxy_info.split('x')[0])
            gy = int(gxy_info.split('x')[1])
            # calc total length
            length = int(info.split('cost = ')[-1].split(',')[0])
            # calc d0
            d0 = int(info.split('interval = ')[-1].split(',')[0])
            # calc time
            time = float(info.split('user ')[-1].split('system')[0])
            write(d0, gx, gy, length, time)
        else:
            write(msg='n,m is out of range (0 < n, m <= 1000)')

    return render(request, "try.html")
