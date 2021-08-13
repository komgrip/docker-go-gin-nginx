FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql mysqli

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions gd zip curl mbstring xml sodium exif

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# php.ini
COPY ./php-ini-overrides.ini /usr/local/etc/php/conf.d

# composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# java
RUN apk add --no-cache openjdk8 && rm -f /etc/apk/repositories
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk \
    PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin

# pdftk
RUN wget https://gitlab.com/pdftk-java/pdftk/-/jobs/924565145/artifacts/raw/build/libs/pdftk-all.jar
RUN mv pdftk-all.jar pdftk.jar
RUN mkdir -p /app/pdftk/bin
RUN (echo '#!/bin/sh' \
    && echo 'java -jar "$0.jar" "$@"')  > /app/pdftk/bin/pdftk
RUN mv pdftk* /app/pdftk/bin
RUN chown -R root:root /app/pdftk
RUN chmod -R 775 /app/pdftk
ENV PATH=$PATH:/app/pdftk/bin

# jasperstarter 
COPY ./jasperstarter /app/jasperstarter
RUN chown -R root:root /app/jasperstarter
RUN chmod -R 775 /app/jasperstarter
ENV PATH=$PATH:/app/jasperstarter/bin
