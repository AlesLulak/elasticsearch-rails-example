FROM ruby:2.3.8 
# Note: changed to ruby 2.3.8  because of Mongo
WORKDIR /root
COPY Gemfile* ./

RUN bundle install

EXPOSE 3000
CMD bundle install \
  && rm -rf tmp/pids \
  && bundle exec rails s -b 0.0.0.0 -e development
