#!/bin/bash
set -e

echo "🚀 Starting FTP Server..."

# Créer les répertoires nécessaires
mkdir -p /var/log/proftpd
mkdir -p /home/ftpuser/ftp

# Configurer les permissions
chown -R ftpuser:ftpuser /home/ftpuser
chmod 755 /home/ftpuser

# Créer le répertoire de travail FTP
mkdir -p /home/ftpuser/ftp
chown ftpuser:ftpuser /home/ftpuser/ftp
chmod 755 /home/ftpuser/ftp

# Créer un lien symbolique vers le volume WordPress
if [ ! -L /home/ftpuser/ftp/wordpress ]; then
    ln -sf /var/www/html /home/ftpuser/ftp/wordpress
    echo "📁 Created symlink to WordPress volume"
fi

# Configurer les permissions pour le volume WordPress
chown -R ftpuser:ftpuser /var/www/html 2>/dev/null || true

# Créer le fichier de mot de passe pour proftpd (format htpasswd)
echo "ftpuser:ftppassword" | chpasswd

echo "✅ FTP Server configuration completed"
echo "📂 WordPress volume mounted at: /home/ftpuser/ftp/wordpress"
echo "🔐 FTP User: ftpuser"
echo "🔑 FTP Password: ftppassword"

# Démarrer proftpd en mode foreground
echo "🚀 Starting proftpd daemon..."
exec proftpd -n -c /etc/proftpd/proftpd.conf
