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

# Étape 5 : Travailler dans ce dossier
WORKDIR /var/www/html

# Étape 6 : Installer Composer manuellement
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Étape 7 : Installer les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Étape 8 : Créer une base SQLite vide dans /tmp
RUN mkdir -p /tmp && touch /tmp/database.sqlite

# Étape 9 : Donner les permissions nécessaires
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Étape 10 : Copier le .env (ou s’assurer qu’il existe dans le dépôt GitHub)
# Si besoin, tu peux gérer tes variables via Render.

# Étape 11 : Générer la clé d'application Laravel
RUN php artisan config:clear && php artisan key:generate --force

# Étape 12 : Exécuter les migrations automatiquement
RUN php artisan migrate --force

# Étape 13 : Exposer le port 80
EXPOSE 80
