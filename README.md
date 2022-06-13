# phmoney_docker

This is the development environment with docker. Is being tested using Windows WSL and Visual Studio Code.

The application https://github.com/kainotomo/phmoney_app should be stored in folder phmoney_app.

It is depended on docker environment https://github.com/kainotomo/local_services

## Installation

*root -> the working directory

* From **root** `git clone https://github.com/kainotomo/local_services.git`
* From **root/local_services** `docker-compose -f local.yml up -d --build` to create general services
* From **root** `git clone https://github.com/kainotomo/phmoney_docker.git`
* From **root/phmoney_docker** `git clone https://github.com/kainotomo/phmoney_app.git`
* From ***root/phmoney_docker** `git clone https://github.com/kainotomo/phmoney_assets.git`
*  For library development 
   - From **root/phmoney_docker/phmoney_assets/app/Providers** `git clone https://github.com/kainotomo/phmoney_provider.git`
   - Add in file **root/phmoney_docker/phmoney_assets/composer.json** below entry
```
"autoload": {
        "psr-4": {
            "Kainotomo\\PHMoney\\": "app/Providers/phmoney_provider/src/",
            ...
        }
    },
```
* From **root/phmoney_docker/docker**: `docker-compose -f local.yml up -d --build`
* From within image phmoney_phmoney docker shell: 
    - `npm install`
    - `composer install`
    - `php artisan phmoney_app:install`
    - `php artisan phmoney_app:update`
    - `php artisan phmoney_provider:install`
    - `php artisan phmoney_provider:update`
    - `php artisan migrate`

That's it!!! Access application at http://phmoney_app.kainotomo.localhost/

*When developing assets access at http://phmoney_assets.kainotomo.localhost/
