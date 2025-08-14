FROM ruby:3.4.5

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

CMD ["bundle", "exec", "rails", "solid_queue:start"]