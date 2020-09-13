from django.urls import path
from . import views

urlpatterns = [
    path('', views.form1, name='form1'),
]