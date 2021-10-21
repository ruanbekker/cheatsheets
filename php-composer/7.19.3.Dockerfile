FROM php:7.3.19-cli

RUN apt-get update \
    && apt-get install \
       default-mysql-client \
       default-libmysqlclient-dev \
       curl git libfreetype6-dev \
       libjpeg62-turbo-dev \
       libmcrypt-dev libpng-dev \
       libzip-dev -y

RUN docker-php-ext-install iconv \
    && pecl install mcrypt-1.0.3 \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install opcache \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install pcntl

#RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN curl -O "https://getcomposer.org/download/1.10.7/composer.phar" \
    && chmod a+x composer.phar \
    && mv composer.phar /usr/bin/composer
RUN composer global require phpunit/phpunit "^7.5"

ENV PATH /root/.composer/vendor/bin:$PATH
RUN ln -s /root/.composer/vendor/bin/phpunit /usr/bin/phpunit
