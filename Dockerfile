FROM ruby:2.3
MAINTAINER Mike Kelly "mike@stateless.co"

# INSTALL GEMS
WORKDIR /tmp
COPY Gemfile /tmp/Gemfile
COPY Gemfile.lock /tmp/Gemfile.lock
RUN bundle install

# NGINX
RUN apt-get -y update
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get -y install nginx
ADD nginx/default /etc/nginx/sites-available/default
ADD nginx/nginx.conf /etc/nginx/nginx.conf

# MOUNT CODE
RUN mkdir /srv/www
WORKDIR /srv/www
ADD . /srv/www/

# BUILD
RUN middleman build

# RUN
EXPOSE 80
CMD nginx
