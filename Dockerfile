FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /atlocs
WORKDIR /atlocs
ADD Gemfile /atlocs/Gemfile
ADD Gemfile.lock /atlocs/Gemfile.lock
RUN bundle install
RUN gem install foreman
ADD . /atlocs
RUN rake assets:precompile
RUN rake db:migrate
CMD bundle install && REDIS_URL=redis://10.128.0.4:6379 GOOGLE_MAPS_API_KEY=AIzaSyBCcBrbwXbj343nhb6JlOBwCofHJ-qhWUg RAILS_ENV=production foreman start