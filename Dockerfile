FROM php:8-cli

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
