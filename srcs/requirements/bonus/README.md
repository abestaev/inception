# Services Bonus - Inception Project

Ce dossier contient les services bonus implémentés pour le projet Inception.

## Services inclus

### Redis Cache
- **Dockerfile** : `redis/Dockerfile`
- **Configuration** : `redis/conf/redis.conf`
- **Description** : Serveur de cache Redis pour optimiser les performances WordPress
- **Port** : 6379
- **Volume** : `/home/albestae/data/redis`

### FTP Server
- **Dockerfile** : `ftp/Dockerfile`
- **Configuration** : `ftp/conf/proftpd.conf`
- **Script de démarrage** : `ftp/tools/start-ftp.sh`
- **Description** : Serveur FTP ProFTPD pointant vers le volume WordPress
- **Ports** : 21 (contrôle), 20 (données), 21000-21010 (passif)
- **Volume** : `/home/albestae/data/wordpress`

## Utilisation

Ces services sont automatiquement démarrés avec `docker compose up` et sont configurés pour fonctionner avec les services principaux (WordPress, MariaDB, Nginx).

### Connexion FTP
- **Hôte** : localhost
- **Port** : 21
- **Utilisateur** : ftpuser
- **Mot de passe** : ftppassword

### Connexion Redis
- **Hôte** : localhost
- **Port** : 6379
- **Mot de passe** : redis_password
