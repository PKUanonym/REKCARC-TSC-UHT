import ast,time,re
from django.shortcuts import render, redirect, reverse
from django.db.models import Q
from . import models
from .models import Movie,Celebrity
from django.core.paginator import Paginator
from django.core.paginator import EmptyPage
from django.core.paginator import PageNotAnInteger


# Create your views here.

def search_home(request):
    title = "Movie Search"
    content = "Anything that can go wrong will go wrong."
    search_words = "在此搜索"
    return render(request, 'search/index.html', locals())


def search_list(request):
    title = "Movie Search"
    content = "Anything that can go wrong will go wrong."
    start_time = time.time()
    keywords = request.GET.get('q')
    type = request.GET.get('type')
    if not keywords or not type:
        return redirect('/')
    words = keywords.split(' ')
    if type=="Movie":
        check1 = "checked"
        movie_type = True
        post_list = Movie.objects.all().order_by("id")
        for word in words:
            post_list = post_list.filter(Q(title__icontains=word) | Q(directors__icontains=word) | Q(actors__icontains=word) | Q(authors__icontains=word) | Q(genre__icontains=word))
        limit = 10
        paginator = Paginator(post_list, limit)
        page = request.GET.get('page')
        try:
            posts = paginator.page(page)  # 获取某页对应的记录
        except PageNotAnInteger:  # 如果页码不是个整数
            posts = paginator.page(1)  # 取第一页的记录
        except EmptyPage:  # 如果页码太大，没有相应的记录
            posts = paginator.page(paginator.num_pages)  # 取最后一页的记录
        end_time = time.time()
        load_time = end_time - start_time
        if keywords == " ":
            title = "所有电影 - Movie Search"
        else:
            title = keywords + " - Movie Search"
        result_num = len(post_list)
        content = "Anything that can go wrong will go wrong."
        pass
    elif type=="Celebrity":
        check2 = "checked"
        celebrity_type = True
        post_list = Celebrity.objects.all().order_by("id")
        for word in words:
            post_list = post_list.filter(
                Q(title__icontains=word) | Q(movies__icontains=word))
        limit = 10
        paginator = Paginator(post_list, limit)
        page = request.GET.get('page')
        try:
            posts = paginator.page(page)  # 获取某页对应的记录
        except PageNotAnInteger:  # 如果页码不是个整数
            posts = paginator.page(1)  # 取第一页的记录
        except EmptyPage:  # 如果页码太大，没有相应的记录
            posts = paginator.page(paginator.num_pages)  # 取最后一页的记录
        end_time = time.time()
        load_time = end_time - start_time
        if keywords == " ":
            title = "所有人物 - Celebrity Search"
        else:
            title = keywords + " - Celebrity Search"
        result_num = len(post_list)
        content = "Anything that can go wrong will go wrong."
        pass
    elif type=="Comment":
        check3 = "checked"
        comment_type = True
        post_list = Movie.objects.all().order_by("id")
        for word in words:
            post_list = post_list.filter(
                Q(title__icontains=word) | Q(comments__contains=word))
        limit = 10
        paginator = Paginator(post_list, limit)
        page = request.GET.get('page')
        try:
            posts = paginator.page(page)  # 获取某页对应的记录
        except PageNotAnInteger:  # 如果页码不是个整数
            posts = paginator.page(1)  # 取第一页的记录
        except EmptyPage:  # 如果页码太大，没有相应的记录
            posts = paginator.page(paginator.num_pages)  # 取最后一页的记录
        comments = []
        for post in posts:
            comment = post.comments
            comment = re.findall("\['(.*?)', '(.*?)', '(.*?)', '(.*?)', '(.*?)', (.*?)\]", comment)
            for item in comment:
                for word in words:
                    if word in item[5]:
                        obj = []
                        obj.append(post.id)
                        obj.append(post.title)
                        obj.append(post.pic_link)
                        for i in item:
                            obj.append(i.replace("\'",""))
                        comments.append(obj)
                        break
        end_time = time.time()
        load_time = end_time - start_time
        result_num = max(len(comments),len(post_list))
        if keywords == " ":
            title = "所有评论 - Comment Search"
        else:
            title = keywords + " - Movie Search"
        content = "Anything that can go wrong will go wrong."
        pass
    return render(request, 'search/search.html', locals())


def show_movie(request, movie_id):
    try:
        post = Movie.objects.get(id=movie_id)
    except:
        return redirect('/')
    genre = ast.literal_eval(post.genre)
    d = ast.literal_eval(post.directors)
    directors = []
    for cele_id,name in d:
        try:
            director = Celebrity.objects.get(id=cele_id)
            directors.append(director)
        except:
            continue

    au = ast.literal_eval(post.authors)
    authors = []
    for cele_id, name in au:
        try:
            author = Celebrity.objects.get(id=cele_id)
            authors.append(author)
        except:
            continue
    ac = ast.literal_eval(post.actors)
    actors = []
    for cele_id, name in ac:
        try:
            actor = Celebrity.objects.get(id=cele_id)
            actors.append(actor)
        except:
            continue
    duration = post.duration[2:]
    comments = post.comments
    comments = re.findall("\['(.*?)', '(.*?)', '(.*?)', '(.*?)', '(.*?)', (.*?)\]", comments)
    return render(request, 'search/movie.html', locals())


def show_celebrity(request, celebrity_id):
    try:
        post = Celebrity.objects.get(id=celebrity_id)
    except:
        return redirect('/')
    try:
        info = re.search(r'[\w\W]*<span class="all hidden">([\w\W]*)</span>',post.info).group(1)
    except:
        info = post.info
    m = ast.literal_eval(post.movies)
    movies = []
    for movie_id, name in m:
        try:
            movie = Movie.objects.get(id=movie_id)
            movies.append(movie)
        except:
            continue
    if len(post.actors):
        a = ast.literal_eval(post.actors)
        a = sorted(a.items(), key=lambda kv: (kv[1], kv[0]), reverse=True)
        actors = []
        for cele_id, num in a[:10]:
            try:
                actor = Celebrity.objects.get(id=cele_id)
                actors.append([actor, num])
            except:
                continue
    return render(request, 'search/celebrity.html', locals())
    # # if not request.session.get('is_login'):
    # #    return redirect('/login')
    # try:
    #     post = Teacher.objects.get(id=celebrity_id)
    # except:
    #     return redirect('/')
    # ignore_list = ['url']
    # params = [[f.verbose_name, post.__dict__[f.name]] for f in post._meta.fields if
    #           f.name not in ignore_list and post.__dict__[f.name]]
    #
    # title = post.name
    # content = post.a5
    #
    # return render(request, 'search/celebrity.html', locals())

