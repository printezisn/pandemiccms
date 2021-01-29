FROM ruby:2.7.2

WORKDIR /app

RUN gem install rubocop
RUN gem install rubocop-rails
RUN gem install rubocop-rspec
RUN gem install rubocop-performance

CMD ["rubocop"]