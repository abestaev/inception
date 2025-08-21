-- Créer l'utilisateur WordPress
CREATE USER IF NOT EXISTS 'wordpress_user'@'%' IDENTIFIED BY 'wordpress_password';

-- Créer la base de données
CREATE DATABASE IF NOT EXISTS wordpress;

-- Accorder les privilèges
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress_user'@'%';
FLUSH PRIVILEGES;
