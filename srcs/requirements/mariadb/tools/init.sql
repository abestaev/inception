-- Créer l'utilisateur WordPress (mot de passe lu depuis le secret)
CREATE USER IF NOT EXISTS 'wordpress_user'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

-- Créer la base de données
CREATE DATABASE IF NOT EXISTS wordpress;

-- Accorder les privilèges
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress_user'@'%';
FLUSH PRIVILEGES;

-- Utiliser la base WordPress
USE wordpress;

-- Créer les tables WordPress de base (structure minimale)
CREATE TABLE IF NOT EXISTS wp_users (
    ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    user_login varchar(60) NOT NULL DEFAULT '',
    user_pass varchar(255) NOT NULL DEFAULT '',
    user_nicename varchar(50) NOT NULL DEFAULT '',
    user_email varchar(100) NOT NULL DEFAULT '',
    user_url varchar(100) NOT NULL DEFAULT '',
    user_registered datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
    user_activation_key varchar(255) NOT NULL DEFAULT '',
    user_status int(11) NOT NULL DEFAULT '0',
    display_name varchar(250) NOT NULL DEFAULT '',
    PRIMARY KEY (ID),
    KEY user_login_key (user_login),
    KEY user_nicename (user_nicename),
    KEY user_email (user_email)
);

CREATE TABLE IF NOT EXISTS wp_usermeta (
    umeta_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    user_id bigint(20) unsigned NOT NULL DEFAULT '0',
    meta_key varchar(255) DEFAULT NULL,
    meta_value longtext,
    PRIMARY KEY (umeta_id),
    KEY user_id (user_id),
    KEY meta_key (meta_key(191))
);

-- Créer les utilisateurs WordPress conformes
-- Supprimer l'utilisateur admin par défaut s'il existe
DELETE FROM wp_usermeta WHERE user_id = 1;
DELETE FROM wp_users WHERE ID = 1;

-- Créer l'utilisateur administrateur (manager)
INSERT INTO wp_users (user_login, user_pass, user_nicename, user_email, user_url, user_registered, user_activation_key, user_status, display_name) 
VALUES ('manager', MD5('securepass123'), 'manager', 'manager@inception.com', '', NOW(), '', 0, 'Manager');

-- Récupérer l'ID du nouvel utilisateur administrateur
SET @manager_id = LAST_INSERT_ID();

-- Donner les capacités d'administrateur
INSERT INTO wp_usermeta (user_id, meta_key, meta_value) VALUES 
(@manager_id, 'wp_capabilities', 'a:1:{s:13:"administrator";b:1;}'),
(@manager_id, 'wp_user_level', '10');

-- Créer un utilisateur normal (editor)
INSERT INTO wp_users (user_login, user_pass, user_nicename, user_email, user_url, user_registered, user_activation_key, user_status, display_name) 
VALUES ('editor', MD5('editorpass123'), 'editor', 'editor@inception.com', '', NOW(), '', 0, 'Editor');

-- Récupérer l'ID de l'éditeur
SET @editor_id = LAST_INSERT_ID();

-- Donner les capacités d'éditeur
INSERT INTO wp_usermeta (user_id, meta_key, meta_value) VALUES 
(@editor_id, 'wp_capabilities', 'a:1:{s:6:"editor";b:1;}'),
(@editor_id, 'wp_user_level', '7');
