FROM debian:bookworm

# Installation de proftpd et outils nécessaires
RUN apt-get update && \
    apt-get install -y \
    proftpd \
    ftp \
    lftp \
    && rm -rf /var/lib/apt/lists/*

# Créer l'utilisateur FTP
RUN useradd -m -s /bin/bash ftpuser && \
    echo "ftpuser:ftppassword" | chpasswd

# Créer les répertoires nécessaires
RUN mkdir -p /home/ftpuser/ftp && \
    mkdir -p /var/log/proftpd

# Configuration proftpd
COPY conf/proftpd.conf /etc/proftpd/proftpd.conf

# Créer le script de démarrage
COPY tools/start-ftp.sh /start-ftp.sh
RUN chmod +x /start-ftp.sh

# Exposer le port FTP
EXPOSE 21 20 21000-21010

# Utilisateur pour l'exécution
USER root

# Démarrer le serveur FTP
CMD ["/start-ftp.sh"]
