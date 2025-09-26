#!/bin/bash
set -e

# Lire les secrets
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)

# Initialiser la base de données si elle n'existe pas
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "🗄️ Initializing MariaDB database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Créer le répertoire pour le socket
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# Créer un fichier d'initialisation temporaire avec les variables
cat > /tmp/init_with_secrets.sql << EOF
-- Créer l'utilisateur WordPress (mot de passe lu depuis le secret)
CREATE USER IF NOT EXISTS 'wordpress_user'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';

-- Créer la base de données
CREATE DATABASE IF NOT EXISTS wordpress;

-- Accorder les privilèges
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress_user'@'%';
FLUSH PRIVILEGES;

-- Utiliser la base WordPress
USE wordpress;
EOF

# Démarrer MariaDB
echo "🚀 Starting MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --init-file=/tmp/init_with_secrets.sql