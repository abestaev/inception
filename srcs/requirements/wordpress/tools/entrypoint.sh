#!/bin/bash
set -e

# Variables d'env (doivent être passées depuis docker-compose)
# WORDPRESS_DB_HOST
# WORDPRESS_DB_USER
# WORDPRESS_DB_NAME
# WORDPRESS_URL
# WORDPRESS_TITLE
# WORDPRESS_ADMIN_USER
# WORDPRESS_ADMIN_EMAIL

# Lire les secrets
WORDPRESS_DB_PASSWORD=$(cat /run/secrets/mysql_password)
WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/wordpress_admin_password)
REDIS_PASSWORD=$(cat /run/secrets/redis_password)

# Attendre que la base de données MariaDB soit prête
echo "⏳ Waiting for MariaDB to be ready..."
sleep 15  # Attendre que MariaDB soit complètement initialisé

# Test de connexion avec retry
echo "🔍 Testing MariaDB connection..."
for i in {1..10}; do
    if mysql -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" -e "SELECT 1;" --silent 2>/dev/null; then
        echo "✅ MariaDB connection successful!"
        break
    else
        echo "⚠️ MariaDB connection attempt $i/10 failed, retrying in 3 seconds..."
        sleep 3
    fi
done

cd /var/www/html

# Copier les fichiers WordPress dans le volume si nécessaire
if [ ! -f "wp-config.php" ] && [ ! -f "index.php" ]; then
    echo "📁 Copying WordPress files to volume..."
    cp -r /var/www/wordpress-source/* /var/www/html/
    chown -R www-data:www-data /var/www/html
    echo "✅ WordPress files copied to volume"
fi

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

    # Ajouter la configuration Redis
    echo "🔧 Configuring Redis cache..."
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --allow-root
    wp config set WP_REDIS_PASSWORD "$REDIS_PASSWORD" --allow-root
    wp config set WP_REDIS_DATABASE 0 --allow-root
    wp config set WP_REDIS_TIMEOUT 1 --allow-root
    wp config set WP_REDIS_READ_TIMEOUT 1 --allow-root
    wp config set WP_REDIS_DATABASE_GLOBAL_GROUP "global" --allow-root
    wp config set WP_REDIS_DATABASE_NON_PERSISTENT_GROUP "non-persistent" --allow-root

    # Vérifier la connexion à la base de données avant l'installation
    echo "🔍 Verifying database connection before WordPress installation..."
    if ! wp db check --allow-root 2>/dev/null; then
        echo "❌ Database connection failed. Attempting to repair..."
        wp db repair --allow-root 2>/dev/null || echo "⚠️ Database repair failed, continuing anyway..."
    fi

    # Nettoyer la base de données si elle contient des tables partielles
    echo "🧹 Cleaning up any existing database tables..."
    wp db reset --yes --allow-root 2>/dev/null || echo "⚠️ Database reset failed, continuing anyway..."

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
    
    # Installer le plugin Redis Object Cache
    echo "🔧 Installing Redis Object Cache plugin..."
    mkdir -p /var/www/html/wp-content/plugins/redis-cache/
    cp /var/www/wordpress-source/wp-content/plugins/redis-cache.php /var/www/html/wp-content/plugins/redis-cache/ 2>/dev/null || \
    echo "⚠️ Could not install Redis plugin automatically"
    
    # Activer le plugin Redis
    wp plugin activate redis-cache --allow-root 2>/dev/null || echo "⚠️ Could not activate Redis plugin"
    
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
