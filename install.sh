if [ ! -d "/app/Cachet" ]; then

# Clone Cachet
git clone -b 2.4 --single-branch https://github.com/cachethq/Cachet.git
cd Cachet/
rm -rf .git/

# Add the .env file
cat > .env <<EOF
APP_ENV=production
APP_DEBUG=false
APP_URL=https://${PROJECT_NAME}.glitch.me
APP_KEY=

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

# Add .gitignore for Cachet/ so the editor doesn't freeze
if [ ! -f "/app/.gitignore" ]; then
cat > .gitignore <<EOF
Cachet/
EOF

fi
fi

