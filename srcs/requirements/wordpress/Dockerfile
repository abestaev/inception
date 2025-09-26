FROM debian:bookworm

# Installation PHP, php-fpm et extensions nécessaires à WordPress
RUN apt-get update && apt-get install -y \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-redis \
    wget \
    tar \
    curl \
    mariadb-client \
    redis-tools \
    && rm -rf /var/lib/apt/lists/*

# Créer le répertoire et télécharger WordPress (version spécifique)
RUN mkdir -p /var/www \
    && wget https://wordpress.org/wordpress-6.4.2.tar.gz -P /tmp \
    && tar -xvzf /tmp/wordpress-6.4.2.tar.gz -C /tmp \
    && rm /tmp/wordpress-6.4.2.tar.gz \
    && mv /tmp/wordpress /var/www/wordpress-source

# Configuration PHP-FPM
RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf \
    && mkdir -p /run/php

# Créer le répertoire et donner les bons droits
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

# WordPress CLI (pratique pour automatiser l’install)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/entrypoint.sh /entrypoint.sh
COPY ./tools/redis-cache.php /var/www/wordpress-source/wp-content/plugins/redis-cache.php
RUN chmod +x /entrypoint.sh


WORKDIR /var/www/html

# php-fpm doit tourner en foreground
ENTRYPOINT ["/entrypoint.sh"]
