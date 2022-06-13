# phmoney_docker

This is the development environment with docker. Is being tested using Windows WSL and Visual Studio Code.

The application https://github.com/kainotomo/phmoney_app should be stored in folder phmoney_app.

It is depended on docker environment https://github.com/kainotomo/local_services

## Installation

*root -> the working directory

* From **root** `git clone https://github.com/kainotomo/local_services.git`
* From **root/local_services** `docker-compose -f local.yml up -d --build` to create general services
* From **root** `git clone https://github.com/kainotomo/phmoney_docker.git`
* From **root/phmoney_docker** `composer create-project kainotomo/phmoney_app`
* From **root/phmoney_docker/docker** `docker-compose -f local.yml up -d --build`
* For assets development from ***root/phmoney_docker/phmoney_assets/public/js** `git clone https://github.com/kainotomo/phmoney_assets.git`
*  For library development 
   - From **root/phmoney_docker/phmoney_assets/app/Providers** `git clone https://github.com/kainotomo/phmoney_library.git`
   - Add in composer.json file below entry
```
"autoload": {
        "psr-4": {
            "Kainotomo\\PHMoney\\": "app/Providers/phmoney_provider/src/",
            ...
        }
    },
```
* Create docker image with: `docker-compose -f local.yml up -d --build`
