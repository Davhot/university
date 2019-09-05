FROM ruby:2.5
ENV LANG C.UTF-8

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs
RUN apt-get update -qq && apt-get install -y tar build-essential libpq-dev postgresql-client apt-utils apt-transport-https --no-install-recommends cron gawk sed  && rm -rf /var/lib/apt/lists/*
RUN apt-get install -y libmagickwand-dev # for RMagick
RUN apt-get install openssl
RUN apt-cache policy openssl libssl1.1

RUN wget https://tar.goaccess.io/goaccess-1.2.tar.gz && \
  tar -xzvf goaccess-1.2.tar.gz && \
  cd goaccess-1.2/ && \
  ./configure --enable-utf8 --enable-geoip=legacy && \
  make && \
  make install

# Обновление ruby
RUN gem pristine --all

RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/log
RUN mkdir -p /usr/src/app/log/apps
RUN mkdir -p /var/run/postgresql

RUN chmod 755 /usr/src/app/log
RUN chmod 755 /usr/src/app/log/apps
RUN chmod 755 /usr/src/app

WORKDIR /usr/src/app
