#!/bin/bash

set -e

# Start ssh
echo "Starting ssh..."
mkdir -p /run/sshd
/usr/sbin/sshd

cd /var/www/html
if [ $PHMONEY_ENV = "azure" ]; then
    echo "First time installation..."
    if [ -e index.nginx-debian.html ]; then
        rm index.nginx-debian.html
    fi
    cd /home/code
    
    echo "Copying code..."
    cp -r -f * /var/www/html
    cp .env.$PHMONEY_ENV /var/www/html/.env.$PHMONEY_ENV
    if [ -f .htaccess ]; then
        cp .htaccess /var/www/html/.htaccess
    fi

fi

cd /var/www/html
chown -R www-data:www-data ../html
echo "Copy environment file..."
cp .env.$PHMONEY_ENV /var/www/html/.env
echo "Database migrating..."
php artisan migrate
php artisan phmoney_app:install
php artisan phmoney_app:update
php artisan phmoney_provider:install
php artisan phmoney_provider:install

if [ $PHMONEY_ENV = "azure" ]; then
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
