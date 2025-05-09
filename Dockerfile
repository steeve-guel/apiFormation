# Étape 1 : Image officielle PHP avec Apache
FROM php:8.2-apache

# Étape 2 : Installer les extensions requises pour Laravel
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    zip \
    sqlite3 \
    libsqlite3-dev \
    git \
    curl \
    && docker-php-ext-install pdo pdo_mysql pdo_sqlite zip mbstring xml

# Étape 3 : Activer mod_rewrite pour Laravel
RUN a2enmod rewrite

# Étape 4 : Configurer Apache pour Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Étape 5 : Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Étape 6 : Copier les fichiers (sans vendor)
COPY . /var/www/html/

# Étape 7 : Installer les dépendances
RUN composer install --no-dev --optimize-autoloader

# Étape 8 : Configurer les permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

# Étape 9 : Créer et configurer SQLite
RUN mkdir -p /var/www/html/database \
    && touch /var/www/html/database/database.sqlite \
    && chown www-data:www-data /var/www/html/database/database.sqlite \
    && chmod 664 /var/www/html/database/database.sqlite

# Étape 10 : Configurer .env pour SQLite
RUN echo "DB_CONNECTION=sqlite" >> /var/www/html/.env \
    && echo "DB_DATABASE=/var/www/html/database/database.sqlite" >> /var/www/html/.env

# Étape 11 : Exposer le port
EXPOSE 80

# Étape 12 : Commande de démarrage
CMD php artisan config:clear \
    && php artisan cache:clear \
    && php artisan route:clear \
    && php artisan migrate --force \
    && apache2-foreground
