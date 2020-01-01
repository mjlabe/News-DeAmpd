FROM python:3.7.6


ENV DJANGO_SETTINGS_MODULE news_deampd.settings
ENV PYTHONUNBUFFERED 1

RUN mkdir /src
WORKDIR /src

# Required for GeoDjango Functionality with MySQL
# https://docs.djangoproject.com/en/2.0/ref/contrib/gis/db-api/
# RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
# RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update
RUN apt-get install -y binutils libproj-dev gdal-bin
RUN apt-get install -y software-properties-common

ADD requirements.txt /src/
RUN pip install -r requirements.txt --upgrade

ADD . /src/

EXPOSE 8000