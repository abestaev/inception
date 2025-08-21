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
sleep 10  # Attendre que MariaDB soit complètement initialisé

# Test de connexion directe
echo "🔍 Testing MariaDB connection..."
if mysql -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" -e "SELECT 1;" --silent 2>/dev/null; then
    echo "✅ MariaDB connection successful!"
else
    echo "⚠️ MariaDB connection failed, but continuing..."
fi

cd /var/www/html

# Vérifier si WordPress est déjà installé
if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "⚙️ Setting up WordPress..."

    # Supprimer wp-config.php s'il existe déjà
    if [ -f "wp-config.php" ]; then
        echo "🗑️ Removing existing wp-config.php..."
        rm -f wp-config.php
    fi

    # Générer wp-config.php
    echo "📝 Creating wp-config.php..."
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root

    # Installer WordPress
    echo "🚀 Installing WordPress..."
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

# Vérifier que WordPress est bien installé
if wp core is-installed --allow-root 2>/dev/null; then
    echo "✅ WordPress installation verified!"
else
    echo "❌ WordPress installation failed, but continuing..."
fi

# Lancer php-fpm en foreground
echo "🚀 Starting PHP-FPM..."
exec php-fpm8.2 -F
