#!/bin/bash
set -e

# Lancer mysqld en arrière-plan pour l'initialisation
mysqld_safe --datadir=/var/lib/mysql &

# Attendre que MySQL soit prêt
until mysqladmin ping --silent; do
    sleep 2
done

echo "✅ MariaDB is ready, setting up database..."

# Créer DB et utilisateur si pas déjà faits
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Arrêter le process background
mysqladmin shutdown

# Redémarrer MariaDB en mode foreground (docker ne doit pas quitter)
exec mysqld_safe --datadir=/var/lib/mysql
