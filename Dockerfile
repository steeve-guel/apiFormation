# Image PHP avec Apache
FROM php:8.2-apache

# Installer extensions PHP requises par Laravel
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip \
    sqlite3 libsqlite3-dev \
    && docker-php-ext-install pdo pdo_sqlite zip

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copier les fichiers Laravel dans le conteneur
COPY . /var/www/html

# Définir le répertoire de travail
WORKDIR /var/www/html

# Installer les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader && \
    chmod -R 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Créer la base SQLite temporaire
RUN mkdir -p /tmp && touch /tmp/database.sqlite

# Définir les variables d'environnement
ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/tmp/database.sqlite
ENV APP_ENV=production
ENV APP_DEBUG=false

# Exposer le port Apache
EXPOSE 80
