from django.http import HttpResponse
from django.shortcuts import render
from thunews.serializers import ItemSerializer
from thunews.models import Thuspideritem, Inverted
from rest_framework.decorators import api_view
from rest_framework import generics
from dateutil.relativedelta import relativedelta
import datetime
import jieba


def index(request):
    return render(request, 'thunews/index.html', {})


def query(request):
    return render(request, 'thunews/query.html', {})


class ApiQuery(generics.ListAPIView):

    serializer_class = ItemSerializer
    keyword_set = set()

    def get(self, request, *args, **kwargs):
        self.request = request
        return self.list(request, *args, **kwargs)

    def get_queryset(self):
        if not self.request.GET.get('keywords'):
            return Thuspideritem.objects.none()

        if not self.keyword_set:
            self.get_keyword_set()

        selected_ids = reduce(lambda s1, s2: s1 & s2,
            map(lambda k: ApiQuery.get_ids_by_keyword(k), self.keyword_set))

        queryset = Thuspideritem.objects.filter(news_id__in=selected_ids)

        datelimit = self.request.GET.get('datelimit')
        if datelimit in ('week', 'month', 'year'):
            current_date = datetime.datetime.now().date()
            if datelimit == 'week':
                mindate = current_date - relativedelta(weeks=1)
            elif datelimit == 'month':
                mindate = current_date - relativedelta(months=1)
            elif datelimit == 'year':
                mindate = current_date - relativedelta(years=1)
            queryset = queryset.filter(date__gte=mindate)

        return queryset.order_by('-date')

    def get_serializer_context(self):
        if not self.keyword_set:
            self.get_keyword_set()
        return {
            'request': self.request,
            'format': self.format_kwarg,
            'view': self,
            'keyword_set': self.keyword_set
        }

    def get_keyword_set(self):
        if not self.request.GET.get('keywords'):
            self.keyword_set = set()
            return
        keywords = self.request.GET['keywords'].split(' ')
        keyword_sets = map(lambda s: set(jieba.cut(s, cut_all=True)), keywords)
        self.keyword_set = reduce(lambda s1, s2: s1 | s2, keyword_sets)

    @staticmethod
    def get_ids_by_keyword(k):
        try:
            word_row = Inverted.objects.get(word=k)
            return set(eval(word_row.in_title)) | set(eval(word_row.in_content))
        except Inverted.DoesNotExist:
            return set()
