if [ ! -d "/app/Cachet" ]; then

echo "Now installing Cachet..."

chmod +x .mysql/run-mysqld.sh
.mysql/run-mysqld.sh &

echo "Started MySQL"

echo "Cloning Cachet"
# Clone Cachet
git clone -b v2.3.18 --single-branch https://github.com/cachethq/Cachet.git
cd Cachet/
rm -rf .git/

# Add the .env file
cat > .env <<EOF
APP_ENV=production
APP_DEBUG=false
APP_URL=https://${PROJECT_NAME}.glitch.me
APP_KEY=${PROJECT_ID}

DB_DRIVER=mysql
DB_HOST=localhost
DB_DATABASE=app
DB_USERNAME=root
DB_PASSWORD=
DB_PORT=3306

CACHE_DRIVER=database
SESSION_DRIVER=database
QUEUE_DRIVER=database
CACHET_EMOJI=false

MAIL_DRIVER=log
MAIL_HOST=null
MAIL_PORT=null
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ADDRESS=null
MAIL_NAME=null
MAIL_ENCRYPTION=tls

REDIS_HOST=null
REDIS_DATABASE=null
REDIS_PORT=null

GITHUB_TOKEN=null
EOF

# Run install scripts
composer install --no-dev -o
php artisan key:generate
php artisan app:install

cd /app

# Add .gitignore for Cachet/ so the editor doesn't freeze
if [ ! -f "/app/.gitignore" ]; then
cat > .gitignore <<EOF
Cachet/
EOF

chmod +x .apache2/run-apache2.sh

echo "Done installing. Refreshing..."
# Refresh the app so everything updates
curl -s -X POST http://localhost:1083/refresh

fi
fi
