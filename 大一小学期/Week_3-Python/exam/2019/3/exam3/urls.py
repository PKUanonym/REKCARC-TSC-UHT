from django.conf.urls import url

from . import view

urlpatterns = [
    url(r'^$',view.initpage),
    url(r'^input$',view.login),
    url(r'^detail$', view.detail)
]