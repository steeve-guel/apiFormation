# Utilise une image officielle PHP avec Apache
FROM php:8.2-apache

# Installe les extensions PHP nécessaires à Laravel et SQLite
RUN apt-get update && apt-get install -y \
    unzip zip sqlite3 libsqlite3-dev libzip-dev \
    && docker-php-ext-install pdo pdo_sqlite zip

# Installe Composer depuis l'image officielle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copie tous les fichiers Laravel dans le conteneur
COPY . /var/www/html

# Définit le répertoire de travail
WORKDIR /var/www/html

# Modifie Apache pour pointer vers le dossier public/
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Active le module rewrite (important pour Laravel)
RUN a2enmod rewrite

# Installe les dépendances Laravel sans les paquets de dev
RUN composer install --no-dev --optimize-autoloader

# Exécuter les migrations dans la base SQLite
RUN php artisan migrate --force

# Donne les bonnes permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Crée une base de données SQLite vide
RUN mkdir -p /tmp && touch /tmp/database.sqlite

# Variables d’environnement de base
ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/tmp/database.sqlite
ENV APP_ENV=production
ENV APP_DEBUG=false

# Expose le port utilisé par Apache
EXPOSE 80
