#!/usr/bin/env bash# exit on error
set -o errexit

bundle install
chmod +x bin/*
bundle exec rails assets:precompile
bundle exec rails assets:clean
