# RAILS 5.2 WITH WEB PACKER
#FROM ruby:2.3
FROM ruby:2.6
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs less libssl-dev
RUN apt-get update -qq && apt-get install -y apt-transport-https ca-certificates
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs imagemagick vim postgresql-client
RUN apt-get install -y xvfb

# FOR SELENIUM TESTING (WHICH IS STILL NOT WORKING)

# Install Google Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome*.deb || apt update && apt-get install -f -y

# 
# ENV FIREFOX_VERSION 57.0
# RUN curl -fL -o /tmp/firefox.tar.bz2 \
#          https://ftp.mozilla.org/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-GB/firefox-$FIREFOX_VERSION.tar.bz2 \
#          && tar -xjf /tmp/firesfox.tar.bz2 -C /tmp/ \
#          && mv /tmp/firefox /opt/firefox \
#          && ln -s /opt/firefox/firefox /usr/bin/firefox
# 
# ENV GECKODRIVER_VERSION 0.27.0
# RUN curl -fL -o /tmp/geckodriver.tar.gz \
#          https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
#          && tar -xzf /tmp/geckodriver.tar.gz -C /tmp/ \
#          && chmod +x /tmp/geckodriver \
#          && mv /tmp/geckodriver /usr/local/bin/

RUN mkdir /app
WORKDIR /app
COPY ./app /app
