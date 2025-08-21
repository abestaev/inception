#!/bin/bash
set -e

# Initialiser la base de données si elle n'existe pas
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "🗄️ Initializing MariaDB database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Créer le répertoire pour le socket
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# Démarrer MariaDB
echo "🚀 Starting MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --init-file=/tmp/init.sql