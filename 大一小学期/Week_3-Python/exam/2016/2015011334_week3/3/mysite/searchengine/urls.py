from django.conf.urls import url
from . import views

app_name = 'searchengine'
urlpatterns = [
#    url(r'^$', views.index, name='index'),
    url(r'^search/$', views.search, name='search'),
#    url(r'^search/(?P<words>.+?)/(?P<page_id>[0-9]+)/$', views.result, name='result'),
#    url(r'^(?P<question_id>[0-9]+)/$', views.detail, name='detail'),
#    url(r'^(?P<question_id>[0-9]+)/results/$', views.results, name='results'),
#    url(r'^(?P<question_id>[0-9]+)/vote/$', views.vote, name='vote'),
]