FROM ruby:3.1.0

WORKDIR /app

RUN gem install rubocop
RUN gem install rubocop-rails
RUN gem install rubocop-rspec
RUN gem install rubocop-performance

CMD ["rubocop"]