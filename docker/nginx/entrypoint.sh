#!/bin/bash

set -e

# Start ssh
echo "Starting ssh..."
mkdir -p /run/sshd
/usr/sbin/sshd

cd /var/www/html
if [ $PHMONEY_ENV == "azure" ]; then
    if [ -d "/var/www/html/phmoney_app" ]; 
    then
        echo "GitHub Pull code..."
        cd phmoney_app
        git pull
        cd ..
    else
        echo "First time installation..."
        git clone --depth 1 --branch $PHMONEY_VERSION https://github.com/kainotomo/phmoney_app.git
    fi
    
fi

echo "Fix permissions..."
chown -R www-data:www-data ../html

echo "Copy environment file..."
cp .env.$PHMONEY_ENV /var/www/html/phmoney_app/.env

cd /var/www/html/phmoney_app
echo "Install Dependencies..."
composer install
if [ $PHMONEY_ENV == "azure" ]; then
    composer update
fi
echo "Database migrating..."
php artisan migrate
php artisan phmoney_app:install
php artisan phmoney_app:update
php artisan phmoney_provider:install
php artisan phmoney_provider:update
php artisan phmoney_cms:install
php artisan phmoney_cms:update

if [ $PHMONEY_ENV == "azure" ]; then
    echo "Clearing cache..."
    php artisan clear-compiled
    php artisan config:clear
    php artisan config:cache
    php artisan view:clear
    php artisan view:cache
    php artisan route:clear
    php artisan route:cache
fi

exec "$@"
