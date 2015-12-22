# Latest Ubuntu LTS
FROM ubuntu:14.04

MAINTAINER  Erik Osterman "e@osterman.com"

# System 
ENV TIMEZONE Etc/UTC
ENV DEBIAN_FRONTEND noninteractive

# Update the package repository
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y redis-server && \
    apt-get install -y locales

ENV REDIS_BIND 0.0.0.0
ENV REDIS_PORT 6379

# Locale specific
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen $LANGUAGE && dpkg-reconfigure locales

# Configure timezone and locale
RUN echo "$TIMEZONE" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
RUN echo "include /etc/redis/docker.conf" >> /etc/redis/redis.conf

# Clean apt cache
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER redis

EXPOSE 6379

# Cannot use CMD array syntax with ENV
CMD /usr/bin/redis-server --bind $REDIS_BIND --port $REDIS_PORT
