FROM ruby:3.4.5

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_23.x | bash - && \
  apt-get update && apt-get install -y nodejs default-libmysqlclient-dev

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY package.json /app/package.json
COPY pnpm-lock.yml /app/pnpm-lock.yml
RUN npm i -g pnpm@latest-10
RUN pnpm i
COPY . /app

COPY ./cmd/rspec/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rspec"]