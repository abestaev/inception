#!/bin/bash
set -e

echo "🎮 Starting Inception Minecraft Server..."

# Variables
SERVER_JAR="minecraft_server.1.20.4.jar"
SERVER_DIR="/opt/minecraft/server"
DATA_DIR="/opt/minecraft/data"
MINECRAFT_JAR="$SERVER_DIR/$SERVER_JAR"

# Créer le lien symbolique vers le dossier de données
if [ ! -L "$SERVER_DIR/world" ]; then
    ln -sf "$DATA_DIR/world" "$SERVER_DIR/world"
fi

# Créer les dossiers nécessaires
mkdir -p "$DATA_DIR/world"
mkdir -p "$DATA_DIR/logs"
mkdir -p "$DATA_DIR/backups"

# Copier les fichiers de configuration s'ils n'existent pas
if [ ! -f "$DATA_DIR/server.properties" ]; then
    cp "$SERVER_DIR/server.properties" "$DATA_DIR/"
fi

if [ ! -f "$DATA_DIR/eula.txt" ]; then
    cp "$SERVER_DIR/eula.txt" "$DATA_DIR/"
fi

# Créer le lien symbolique vers les logs
if [ ! -L "$SERVER_DIR/logs" ]; then
    ln -sf "$DATA_DIR/logs" "$SERVER_DIR/logs"
fi

# Vérifier que le fichier JAR existe
if [ ! -f "$MINECRAFT_JAR" ]; then
    echo "❌ Error: Minecraft server JAR not found at $MINECRAFT_JAR"
    exit 1
fi

# Afficher les informations du serveur
echo "📋 Server Information:"
echo "   Version: 1.20.4"
echo "   Port: 25565"
echo "   Max Players: 20"
echo "   Gamemode: Survival"
echo "   Difficulty: Normal"
echo "   World: $DATA_DIR/world"

# Démarrer le serveur Minecraft
echo "🚀 Starting Minecraft server..."
cd "$SERVER_DIR"

# Utiliser les propriétés du dossier de données
exec java -Xmx2G -Xms1G -jar "$MINECRAFT_JAR" nogui --world-dir="$DATA_DIR"
