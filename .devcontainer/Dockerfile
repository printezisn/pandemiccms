FROM ruby:3.4.5

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
  apt-get update && apt-get install -y nodejs default-libmysqlclient-dev libvips

WORKDIR /workspace