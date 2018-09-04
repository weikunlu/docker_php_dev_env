FROM php:7-fpm-alpine

RUN apk --update add wget \
  curl \
  git \
  grep \
  build-base \
  libmemcached-dev \
  libmcrypt-dev \
  libxml2-dev \
  postgresql-dev \
  imagemagick-dev \
  pcre-dev \
  libtool \
  make \
  autoconf \
  g++ \
  cyrus-sasl-dev \
  libgsasl-dev \
  supervisor


RUN docker-php-ext-install mbstring pdo pdo_pgsql tokenizer xml
RUN pecl channel-update pecl.php.net \
    && pecl install memcached \
    && pecl install imagick \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable mcrypt

RUN rm /var/cache/apk/* && \
    mkdir -p /var/www

COPY supervisord-app.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]