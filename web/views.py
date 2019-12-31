from GoogleNews import GoogleNews
from django.shortcuts import render
from django.views import View


class NewsViewSet(View):
    @staticmethod
    def get(request):
        news = GoogleNews()
        news.get_news(deamplify=True)
        return render(request, 'news.html', {'data': news.result()})
