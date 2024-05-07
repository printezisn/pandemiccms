FROM ruby:3.3.0

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
  apt-get update && apt-get install -y nodejs default-libmysqlclient-dev libvips

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
RUN npm i
COPY . /app

COPY ./docker/app/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0"]