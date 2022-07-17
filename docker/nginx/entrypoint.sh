#!/bin/bash

set -e

# Start ssh
echo "Starting ssh..."
mkdir -p /run/sshd
/usr/sbin/sshd

# setup production
if [ $PHCOMM_ENV = "production" ]; then
    echo "Setup production environment..."
    cd /home/code
    echo "Copying code..."
    cp -r -f * /var/www/html
    cp .env.azure /var/www/html/.env
    if [ -f .htaccess ]; then
        cp .htaccess /var/www/html/.htaccess
    fi
    cd /var/www/html
    echo "Installing dependencies..."
    composer install
    if [ $PHCOMM_BUILD_ASSETS = "true" ]; then
        echo "Building assets..."
        npm install
        npm run production
    fi
    echo "Database migrating..."
    php artisan migrate --force
    echo "Clearing cache..."
    php artisan clear-compiled
    php artisan config:clear
    php artisan config:cache
    php artisan view:clear
    php artisan view:cache
    php artisan route:clear
    php artisan route:cache
fi

# setup local
if [ $PHCOMM_ENV = "local" ]; then
    echo "Setup local environment..."
    cd /var/www/html
    echo "Copying env file..."
    cp .env.local .env

    if [ $PHCOMM_SUPERVISOR = "true" ]; then
        echo "Starting supervisor..."
        cd /home/docker
        cp crontab /etc/cron.d/phcomm
        cp supervisord.local.conf /etc/supervisor/conf.d/phcomm.conf
        /usr/bin/supervisord
    fi

fi

exec "$@"
