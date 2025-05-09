# Étape 1 : Image officielle PHP avec Apache
FROM php:8.2-apache

# Étape 2 : Installer les extensions requises pour Laravel
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

# Étape 5 : Changer le DocumentRoot d’Apache pour Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Étape 6 : Reconfigurer Apache pour pointer sur /public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Étape 7 : Travailler dans ce dossier
WORKDIR /var/www/html

# Étape 8 : Installer Composer manuellement
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Étape 9 : Installer les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Étape 10 : Créer une base SQLite vide dans /tmp
RUN mkdir -p /tmp && touch /tmp/database.sqlite

# Étape 11 : Donner les permissions nécessaires
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Étape 12 : Exposer le port 80
EXPOSE 80

# Étape 13 : Lancer les migrations + Apache au démarrage
CMD php artisan config:cache && php artisan migrate --force && apache2-foreground
