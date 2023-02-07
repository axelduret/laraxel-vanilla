# Use this docker container to build from
FROM php:8.2.2-apache-buster

# install all the system dependencies and enable PHP modules
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libpq-dev \
    libpng-dev \
    libmcrypt-dev \
    libonig-dev \
    libzip-dev \
    git \
    zip \
    unzip \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install \
    intl \
    mbstring \
    pcntl \
    zip \
    gd \
    opcache

# install postgres
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql
RUN docker-php-ext-enable pdo_pgsql

# set our application folder as an environment variable
ENV APP_HOME /var/www/html

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
COPY composer.json $APP_HOME

# install all PHP dependencies
RUN composer install --no-interaction

ENV PATH vendor/bin:$PATH

# change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# enable apache module rewrite
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enmod headers

# Virtual Host
COPY ./docker/config/server/apacheConfig.conf /etc/apache2/sites-available/000-default.conf

# PHP ini
COPY ./docker/config/php /usr/local/etc/php/conf.d/

# mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origin-
RUN a2enmod rewrite headers
