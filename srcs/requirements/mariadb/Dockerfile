FROM debian:bookworm

# Installer mariadb-server
RUN apt-get update && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Copier script d’initialisation
COPY ./tools/init-db.sh /init-db.sh
RUN chmod +x /init-db.sh

# Exposer le port MariaDB
EXPOSE 3306

# Lancer MariaDB via script
CMD ["/init-db.sh"]
