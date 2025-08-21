#!/bin/bash

echo "🔍 Test de configuration Inception"
echo "=================================="

# Vérifier que le fichier .env existe
if [ ! -f ".env" ]; then
    echo "❌ Fichier .env manquant. Copiez env.example vers .env"
    echo "   cp env.example .env"
    exit 1
fi

echo "✅ Fichier .env trouvé"

# Vérifier les variables d'environnement
echo ""
echo "📋 Variables d'environnement:"
source .env

echo "   MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD:+✅ défini}"
echo "   MYSQL_DATABASE: ${MYSQL_DATABASE:+✅ défini}"
echo "   MYSQL_USER: ${MYSQL_USER:+✅ défini}"
echo "   MYSQL_PASSWORD: ${MYSQL_PASSWORD:+✅ défini}"
echo "   WORDPRESS_URL: ${WORDPRESS_URL:+✅ défini}"
echo "   WORDPRESS_TITLE: ${WORDPRESS_TITLE:+✅ défini}"

# Vérifier Docker
echo ""
echo "🐳 Vérification Docker:"
if command -v docker &> /dev/null; then
    echo "   Docker: ✅ installé"
    echo "   Version: $(docker --version)"
else
    echo "   Docker: ❌ non installé"
    exit 1
fi

if docker compose version &> /dev/null; then
    echo "   Docker Compose: ✅ installé"
    echo "   Version: $(docker compose version)"
else
    echo "   Docker Compose: ❌ non installé"
    exit 1
fi

# Vérifier les ports
echo ""
echo "🔌 Vérification des ports:"
if netstat -tuln | grep -q ":80 "; then
    echo "   Port 80: ⚠️  déjà utilisé"
else
    echo "   Port 80: ✅ disponible"
fi

if netstat -tuln | grep -q ":443 "; then
    echo "   Port 443: ⚠️  déjà utilisé"
else
    echo "   Port 443: ✅ disponible"
fi

if netstat -tuln | grep -q ":3306 "; then
    echo "   Port 3306: ⚠️  déjà utilisé"
else
    echo "   Port 3306: ✅ disponible"
fi

echo ""
echo "🎯 Configuration prête! Vous pouvez maintenant exécuter:"
echo "   make build"
