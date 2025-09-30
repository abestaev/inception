FROM debian:bookworm

# Installation des dépendances
RUN apt-get update && \
    apt-get install -y \
    openjdk-17-jdk \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Créer l'utilisateur minecraft
RUN useradd -m -s /bin/bash minecraft

# Créer les répertoires
RUN mkdir -p /opt/minecraft/server && \
    mkdir -p /opt/minecraft/data && \
    chown -R minecraft:minecraft /opt/minecraft

# Télécharger et installer le serveur Minecraft
WORKDIR /opt/minecraft/server

# Télécharger le serveur Minecraft (version 1.20.4)
RUN wget -O minecraft_server.1.20.4.jar https://piston-data.mojang.com/v1/objects/5b868151bd02b2bea6c39b3a6c4a6c4f3d8b5d5b/server.jar && \
    chown minecraft:minecraft minecraft_server.1.20.4.jar

# Copier les fichiers de configuration
COPY conf/server.properties /opt/minecraft/server/
COPY conf/eula.txt /opt/minecraft/server/
COPY tools/start-minecraft.sh /opt/minecraft/server/
RUN chmod +x /opt/minecraft/server/start-minecraft.sh && \
    chown -R minecraft:minecraft /opt/minecraft

# Créer le volume pour les données
VOLUME ["/opt/minecraft/data"]

# Exposer le port Minecraft
EXPOSE 25565

# Utilisateur minecraft
USER minecraft

# Démarrer le serveur
CMD ["/opt/minecraft/server/start-minecraft.sh"]