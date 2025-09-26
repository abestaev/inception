FROM debian:bookworm

# Installation de Redis
RUN apt-get update && \
    apt-get install -y redis-server && \
    rm -rf /var/lib/apt/lists/*

# Créer le répertoire pour les données Redis
RUN mkdir -p /var/lib/redis && \
    chown redis:redis /var/lib/redis

# Configuration Redis
RUN sed -i 's/^# maxmemory <bytes>/maxmemory 256mb/' /etc/redis/redis.conf && \
    sed -i 's/^# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/' /etc/redis/redis.conf && \
    sed -i 's/^bind 127.0.0.1 ::1/bind 0.0.0.0/' /etc/redis/redis.conf && \
    sed -i 's/^# requirepass foobared/requirepass redis_password/' /etc/redis/redis.conf

# Exposer le port Redis
EXPOSE 6379

# Utilisateur Redis
USER redis

# Démarrer Redis
CMD ["redis-server", "/etc/redis/redis.conf"]
