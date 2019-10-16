FROM ruby:2.4.4
COPY Gemfile* ./
WORKDIR /root

RUN bundle install

EXPOSE 3000
CMD bundle install \
  && bundle exec rails s -b 0.0.0.0
