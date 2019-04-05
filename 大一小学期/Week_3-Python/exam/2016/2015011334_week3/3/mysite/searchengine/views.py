from django.shortcuts import get_object_or_404, render
from django.http import HttpResponse, HttpResponseRedirect, Http404
from django.urls import reverse
from .models import Event
import jieba

def search(request):
    if request.POST.has_key('add'):
        event = request.POST['event']
        ttime = request.POST['ttime']
        Event.objects.create(event=event, ttime=ttime)
        return render(request, 'searchengine/search.html', {'events': None})
    elif request.POST.has_key('query'):
        event = request.POST['event']
        ttime = request.POST['ttime']
        if event:
            result = Event.objects.filter(event=event)
        else:
            result = Event.objects
        if ttime:
            result = result.filter(ttime=ttime)
        else:
            result = result
        return render(request, 'searchengine/search.html', {'events': result.all()})
    else:
        id = -1
        for i in range(1000):
            if request.POST.has_key('del'+str(i)):
                Event.objects.filter(id=i).delete()
                break
    return render(request, 'searchengine/search.html', {'events': None})