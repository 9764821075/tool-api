#!/bin/sh

rm -f tmp/pids/server.pid

bin/wait_for_db
bundle exec rails tool:db:setup
exec bundle exec rails s -p ${APP_PORT}
