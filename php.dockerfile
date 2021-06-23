FROM php:7.4-fpm-alpine

RUN mkdir -p /php/src
WORKDIR /php/src

RUN docker-php-ext-install pdo pdo_mysql

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions gd zip curl mbstring xml sodium exif

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# php.ini
COPY ./php-ini-overrides.ini /usr/local/etc/php/conf.d

# composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer