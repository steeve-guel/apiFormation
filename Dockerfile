# Étape 1 : Image officielle PHP avec Apache
FROM php:8.2-apache

# Étape 2 : Installer les extensions requises
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    unzip \
    zip \
    sqlite3 \
    libsqlite3-dev \
    git \
    curl \
    && docker-php-ext-install pdo pdo_sqlite zip

# Étape 3 : Activer mod_rewrite pour Laravel
RUN a2enmod rewrite

# Étape 4 : Copier les fichiers du projet
COPY . /var/www/html

# Étape 5 : Définir le document root d’Apache sur /public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Étape 6 : Travailler dans le bon dossier
WORKDIR /var/www/html

# Étape 7 : Installer Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Étape 8 : Installer les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Étape 9 : Créer la base SQLite dans storage
RUN touch /var/www/html/storage/database.sqlite && chmod 777 /var/www/html/storage/database.sqlite

# Étape 10 : Donner les bonnes permissions aux dossiers Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Étape 11 : Exécuter les migrations et démarrer Apache
CMD php artisan config:clear && \
    php artisan key:generate --force && \
    php artisan migrate --force && \
    apache2-foreground

# Étape 12 : Exposer le port
EXPOSE 80
