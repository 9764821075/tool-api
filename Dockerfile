FROM ruby:2.7.3-slim-buster
# FROM ruby:2.7.3-alpine3.12

RUN apt-get update -qq \
 && apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    libpq-dev \
    postgresql-client \
    libsqlite3-dev \
    graphicsmagick \
    imagemagick \
    git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV LANG C.UTF-8
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

COPY .ruby-version .
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle config --global frozen 1
RUN bundle install --without development test

RUN mkdir ./storage
COPY config.ru .
COPY Rakefile .
COPY app ./app
COPY bin ./bin
COPY config ./config
COPY db ./db
COPY lib ./lib

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
