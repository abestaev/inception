FROM debian:bookworm


# mise a jour et installation
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    vim \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.keyout -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=albestae.42.fr/UID=albestae"

RUN mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g", "daemon off;"]