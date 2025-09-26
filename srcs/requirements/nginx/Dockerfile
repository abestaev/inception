FROM debian:bookworm

# Mise à jour et installation
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    vim \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Créer les répertoires nécessaires
RUN mkdir -p /etc/nginx/ssl /var/run/nginx /var/www/html

# Générer un certificat SSL auto-signé
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=albestae.42.fr/UID=inception"

# Copier la configuration Nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Donner les bons droits
RUN chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Exposer les ports 80 et 443
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]