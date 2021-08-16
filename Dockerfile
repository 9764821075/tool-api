FROM ruby:2.7.3-slim-buster

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  apt-utils \
  build-essential \
  libpq-dev \
  postgresql-client \
  libsqlite3-dev \
  git \
  && apt-get clean

RUN mkdir -p /tool/api/tmp

WORKDIR /tool/api

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

COPY .ruby-version /tool/api/.ruby-version
COPY Gemfile /tool/api/Gemfile
COPY Gemfile.lock /tool/api/Gemfile.lock
RUN bundle config --global frozen 1
RUN bundle install --without development test

COPY app /tool/api/app
COPY bin /tool/api/bin
COPY config /tool/api/config
COPY db /tool/api/db
COPY lib /tool/api/lib
COPY config.ru /tool/api/config.ru
COPY Rakefile /tool/api/Rakefile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
