FROM debian:bookworm

# Installation de PHP et Apache
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    libapache2-mod-php8.2 \
    php8.2-mysql \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Télécharger et installer Adminer
RUN wget -O /tmp/adminer.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
    mv /tmp/adminer.php /var/www/html/adminer.php && \
    chown www-data:www-data /var/www/html/adminer.php

# Configuration Apache
RUN a2enmod rewrite && \
    a2enmod php8.2 && \
    a2enmod headers

# Créer la configuration Apache personnalisée
COPY conf/adminer.conf /etc/apache2/sites-available/adminer.conf
RUN a2ensite adminer.conf && \
    a2dissite 000-default

# Créer le script de démarrage
COPY tools/start-adminer.sh /start-adminer.sh
RUN chmod +x /start-adminer.sh

# Exposer le port 8080
EXPOSE 8080

# Utilisateur pour l'exécution
USER root

# Démarrer Apache
CMD ["/start-adminer.sh"]
