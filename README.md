# laraxel-vanilla

laraxel-vanilla is just a simple Docker startup kit  with :

- php:8.2.2-apache-buster

- postgres:latest

- dpage/pgadmin4:latest

- redis:latest

- redislabs/redisinsight:latest

## Installation
After cloning this repository, move to the root directory and follow these steps :

``cp .env.example .env``

``docker build .``

``docker compose up``

``composer install``

If you need to install phpstan/phpstan :

``cd tools/``

``composer install``

To run phpstan from the root directory :

``tools/vendor/bin/phpstan``
