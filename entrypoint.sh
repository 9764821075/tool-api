#!/bin/bash
set -e

rm -f tmp/pids/server.pid

bin/wait_for_db
bundle exec rails tool:db:setup
bundle exec rails s
