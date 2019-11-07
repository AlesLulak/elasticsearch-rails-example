FROM ruby:2.4.4
WORKDIR /root
COPY Gemfile* ./

RUN bundle install

EXPOSE 3000
CMD bundle install \
  && rm -rf tmp/pids \
  && bundle exec rails s -b 0.0.0.0 -e development
