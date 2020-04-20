# https://hub.docker.com/_/php/
# PHP7-CLI
#https://github.com/TrafeX/docker-php-nginx
FROM chialab/php:7.3-fpm

MAINTAINER Pavel Mikulik <esclkm@gmail.com>

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get update && apt-get install -y libmcrypt-dev \
    libmagickwand-dev libmagickcore-dev libzip-dev --no-install-recommends \
    && pecl install imagick \
    && pecl install mcrypt-1.0.2
RUN docker-php-ext-enable mcrypt \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip

RUN mkdir /app && chmod 1777 /app
WORKDIR /app

COPY ./ /app/
RUN composer --version

ENV COMPOSER_MEMORY_LIMIT=-1
RUN php -r "echo ini_get('memory_limit').PHP_EOL;"
RUN composer install --no-scripts
CMD sh bin/console server:run