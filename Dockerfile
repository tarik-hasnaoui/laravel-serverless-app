FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    libcurl4-openssl-dev \
    default-mysql-client \
    nodejs \
    npm \
    awscli \
    && docker-php-ext-install pdo_mysql mbstring zip bcmath pcntl xml fileinfo

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Serverless CLI globally
RUN npm install -g serverless

WORKDIR /var/www

COPY . .

RUN chown -R www-data:www-data storage bootstrap/cache
RUN chmod -R 775 storage bootstrap/cache

RUN composer install --no-dev --optimize-autoloader --prefer-dist --no-scripts

EXPOSE 9000

CMD ["php-fpm"]
