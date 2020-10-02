from django.shortcuts import render
from django.views import View
from django.views.decorators.cache import cache_page

from newscatcher import Newscatcher
from GoogleNews import GoogleNews


from news_deampd import settings

CACHE_TTL = getattr(settings, 'CACHE_TTL', settings.SESSION_EXPIRATION)


class NewsViewSet(View):
    @staticmethod
    @cache_page(CACHE_TTL)
    def get(request):
        news = GoogleNews()
        news.get_news(deamplify=True)
        return render(request, 'news.html', {'data': news.result()})


class NewscatcherView(View):
    news = {}
    websites = []
    topics = ['news', 'tech',  'science', 'world', 'business', 'finance', 'politics', 'economics', 'travel',]

    @cache_page(CACHE_TTL)
    def get(self, request):
        return render(request, 'news.html', {'data': self.news})

    def get_news(self):
        for topic in self.topics:
            for website in self.websites:
                nc = Newscatcher(website=website, topic=topic)

                results = nc.get_news()
                self.news[topic] = results['articles'][:10]