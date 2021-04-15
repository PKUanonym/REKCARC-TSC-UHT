from django.urls import path, include
from django.conf.urls import url
from . import views


urlpatterns = [
    path('', views.search_home),
    path('search/', views.search_list),
    path('movie/<int:movie_id>', views.show_movie),
    path('celebrity/<int:celebrity_id>', views.show_celebrity)
]
