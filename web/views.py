from GoogleNews import GoogleNews
from django.shortcuts import render
from django.views import View
from django.views.decorators.cache import cache_page

from news_deampd import settings

CACHE_TTL = getattr(settings, 'CACHE_TTL', settings.SESSION_EXPIRATION)


class NewsViewSet(View):
    @staticmethod
    @cache_page(CACHE_TTL)
    def get(request):
        news = GoogleNews()
        news.get_news(deamplify=True)
        return render(request, 'news.html', {'data': news.result()})
