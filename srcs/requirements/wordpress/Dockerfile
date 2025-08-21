FROM debian:bookworm

# Installation PHP, php-fpm et extensions nécessaires à WordPress
RUN apt-get update && apt-get install -y \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    wget \
    tar \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Téléchargement de WordPress (dernière version stable)
RUN wget https://wordpress.org/latest.tar.gz -P /var/www \
    && tar -xvzf /var/www/latest.tar.gz -C /var/www \
    && rm /var/www/latest.tar.gz \
    && mv /var/www/wordpress /var/www/html

# Configuration PHP-FPM
RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf \
    && mkdir -p /run/php

# Donne les bons droits
RUN chown -R www-data:www-data /var/www/html

# WordPress CLI (pratique pour automatiser l’install)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


WORKDIR /var/www/html

# php-fpm doit tourner en foreground
ENTRYPOINT ["/entrypoint.sh"]
