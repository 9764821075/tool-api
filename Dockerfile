# STAGE: builder
FROM ruby:2.7.3-alpine3.12 as builder

# Install build packages
RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
    build-base \
    tzdata \
    postgresql-dev \
    git \
 && rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

WORKDIR /app

# Install Ruby gems
COPY .ruby-version .
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle config --local frozen 1 \
 && bundle config --local jobs 4 \
 && bundle config --local without development:test \
 && bundle config --local path /app/vendor \
 && bundle install


# STAGE: final
FROM ruby:2.7.3-alpine3.12

# Install runtime packages
RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
    libpq \
    tzdata \
    graphicsmagick \
 && rm -rf /var/lib/apt/lists/*

# Add non-root user
RUN addgroup -S appgroup \
 && adduser -S appuser -G appgroup

USER appuser
WORKDIR /app

ENV LANG=C.UTF-8
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

# Setup ruby gems
COPY --chown=appuser .ruby-version .
COPY --chown=appuser Gemfile .
COPY --chown=appuser Gemfile.lock .
COPY --chown=appuser --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --chown=appuser --from=builder /app/vendor/ /app/vendor/

# Copy app files
RUN mkdir ./storage
COPY --chown=appuser config.ru .
COPY --chown=appuser Rakefile .
COPY --chown=appuser app ./app
COPY --chown=appuser bin ./bin
COPY --chown=appuser config ./config
COPY --chown=appuser db ./db
COPY --chown=appuser lib ./lib

# Prepare entrypoint
COPY --chown=appuser entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
