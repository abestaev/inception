#!/bin/bash
set -e

# Variables d'env (doivent être passées depuis docker-compose)
# WORDPRESS_DB_HOST
# WORDPRESS_DB_USER
# WORDPRESS_DB_PASSWORD
# WORDPRESS_DB_NAME
# WORDPRESS_URL
# WORDPRESS_TITLE
# WORDPRESS_ADMIN_USER
# WORDPRESS_ADMIN_PASSWORD
# WORDPRESS_ADMIN_EMAIL

# Attendre que la base de données MariaDB soit prête
echo "⏳ Waiting for MariaDB to be ready..."
until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    sleep 2
done
echo "✅ MariaDB is ready!"

cd /var/www/html

# Vérifier si WordPress est déjà installé
if ! wp core is-installed --allow-root; then
    echo "⚙️ Setting up WordPress..."

    # Générer wp-config.php
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root

    # Installer WordPress
    wp core install \
        --url="$WORDPRESS_URL" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    echo "🎉 WordPress installed successfully!"
else
    echo "✅ WordPress is already installed."
fi

# Lancer php-fpm en foreground
exec php-fpm7.4 -F
