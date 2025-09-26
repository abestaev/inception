#!/bin/bash
set -e

echo "🚀 Starting Adminer..."

# Créer les répertoires nécessaires
mkdir -p /var/log/apache2
mkdir -p /var/run/apache2

# Configurer les permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Créer un fichier de configuration Adminer personnalisé
cat > /var/www/html/adminer-config.php << 'EOF'
<?php
// Configuration Adminer personnalisée
function adminer_object() {
    class AdminerCustomization extends Adminer {
        function name() {
            return 'Inception Database Admin';
        }
        
        function credentials() {
            return array('mariadb', 'wordpress_user', '');
        }
        
        function database() {
            return 'wordpress';
        }
        
        function login($login, $password) {
            return true; // Auto-login pour simplifier
        }
        
        function loginForm() {
            echo '<input type="hidden" name="auth[driver]" value="server">';
            echo '<input type="hidden" name="auth[server]" value="mariadb">';
            echo '<input type="hidden" name="auth[username]" value="wordpress_user">';
            echo '<input type="hidden" name="auth[password]" value="">';
            echo '<input type="hidden" name="auth[db]" value="wordpress">';
        }
    }
    return new AdminerCustomization;
}

include "./adminer.php";
?>
EOF

echo "✅ Adminer configuration completed"
echo "🔗 Adminer will be available at: http://localhost:8080"
echo "🗄️ Database: wordpress"
echo "👤 User: wordpress_user"

# Démarrer Apache en mode foreground
echo "🚀 Starting Apache daemon..."
exec apache2ctl -D FOREGROUND
