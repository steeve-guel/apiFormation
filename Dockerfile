# Utilise PHP avec Apache intégré
FROM php:8.2-apache

# Installe les extensions nécessaires à Laravel + SQLite
RUN apt-get update && apt-get install -y \
    unzip zip sqlite3 libsqlite3-dev libzip-dev \
    && docker-php-ext-install pdo pdo_sqlite zip

# Installe Composer depuis l'image officielle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copie les fichiers Laravel dans le conteneur
COPY . /var/www/html

# Définit le répertoire de travail
WORKDIR /var/www/html

# Installe les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Fixe les permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Crée une base SQLite vide temporaire
RUN mkdir -p /tmp && touch /tmp/database.sqlite

# Variables d'environnement par défaut
ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/tmp/database.sqlite
ENV APP_ENV=production
ENV APP_DEBUG=false

# Expose le port Apache
EXPOSE 80
