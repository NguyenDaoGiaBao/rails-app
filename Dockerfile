FROM ruby:3.4.4

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    rustc \
    libssl-dev \
    libyaml-dev \
    zlib1g-dev \
    libgmp-dev \
    default-libmysqlclient-dev \
    nodejs \
    yarn \
    tzdata

RUN useradd -m www

RUN mkdir -p /app && chown -R www:www /app

WORKDIR /app 

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install

RUN chown -R www:www /usr/local/bundle

ADD . /app

USER www