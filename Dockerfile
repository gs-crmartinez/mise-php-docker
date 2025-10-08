FROM php:7.4-cli

# Install Composer 2.2 (compatible with PHP 7.4)
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

# Install Xdebug 3.1.6 (last version compatible with PHP 7.4)
RUN pecl install xdebug-3.1.6 && docker-php-ext-enable xdebug

# Configure Xdebug defaults (off by default, enable via XDEBUG_MODE env var)
RUN echo "xdebug.mode=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN docker-php-ext-install pdo pdo_mysql mysqli

WORKDIR /app
