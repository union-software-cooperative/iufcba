# RAILS 5.2 WITH WEB PACKER
FROM ruby:2.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs less
RUN apt-get update -qq && apt-get install -y apt-transport-https ca-certificates
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs imagemagick vim postgresql-client

RUN mkdir /app
WORKDIR /app
COPY ./app /app
