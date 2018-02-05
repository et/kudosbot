
# FROM markadams/chromium-xvfb
# WORKDIR /usr/src/app
#
# RUN apt-get install -y ruby bundler git


FROM ruby:2.4
RUN mkdir /usr/src/app
ADD . /usr/src/app
WORKDIR /usr/src/app

RUN gem install bundler

RUN bundle install

EXPOSE 5000