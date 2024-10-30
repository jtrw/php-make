# PHP Make

Useful PHP Makefile for PHP projects.
Simple collections of make commands to increase productivity.
In this project I collect useful commands for PHP projects. Most of the commands are related to Docker projects.

## Install
1. `composer require jtrw/php-make`
2. Run `/vendor/bin/php-make` command for copy template Makefile to your project if Makefile exists it will be not overwritten.
3. If you use your own Makefile, you can add the following line to your Makefile:
```makefile
include vendor/jtrw/php-make/.make/utils.mk
include vendor/jtrw/php-make/.make/colours.mk
include vendor/jtrw/php-make/.make/docker-compose-shared-services.mk
include vendor/jtrw/php-make/.make/composer.mk
include vendor/jtrw/php-make/.make/static-analysis.mk
include vendor/jtrw/php-make/.make/migrations-symfony.mk
```
4. Add to your .env file variable `PHP_FPM_NAME` and `APP_ENV` for example:
```dotenv
PHP_FPM_NAME=php-fpm
APP_ENV=dev
```
5. Use `make help` to see all available commands.

## Usage

image: ![make help](/docs/make-help.jpg)

## Description

File `composer.mk` contains commands for composer.

File `docker.mk` contains commands for docker.

File `migrations-symfony.mk` contains commands for Symfony migrations.

File `migrations-laravel.mk` contains commands for Laravel migrations.

File `static-analysis.mk` contains commands for static analysis.

File `utils.mk` contains useful commands.

File `docker-compose-shared-services.mk` contains commands for docker-compose. Shared services `docker-compose-shared-services.yml` it is a file with shared services for docker-compose. For example it's services that use in local development environment.
Example of `docker-compose-shared-services.yml`:
```yaml
version: "3.7"

services:
  mysql:
    container_name: ${APP_COMPOSE_PROJECT_NAME}_mysql
    image: mysql:8.0
    networks:
      - backend
    cap_add:
      - SYS_NICE
    restart: always
    volumes:
      - mysql:/var/lib/mysql
    ports:
      - 3306:3306
    env_file:
      - .env
    command: --sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
  rabbitmq3:
    container_name: ${APP_COMPOSE_PROJECT_NAME}_rabbitmq
    image: rabbitmq:3.11.4-management-alpine
    networks:
      - backend
    environment:
      RABBITMQ_DEFAULT_USER: ${RABBITMQ_USER}
      RABBITMQ_DEFAULT_PASS: ${RABBITMQ_PASS}
    ports:
      - '5674:5672'
      - '15674:15672'
  redis:
    container_name: ${APP_COMPOSE_PROJECT_NAME}_redis
    image: redis:latest
    networks:
      - backend
    volumes:
      - ./.docker/redis/redis-cache/redis.conf:/usr/local/etc/redis/redis.conf
      - redis:/data
    command: /usr/local/etc/redis/redis.conf
    ports:
      - 6381:6379
    healthcheck:
      test: [ "CMD", "bash", "-c", "exec 3<> /dev/tcp/127.0.0.1/6379 && echo PING >&3 && head -1 <&3 | grep PONG" ]
      interval: 5s
      timeout: 10s
      retries: 5
    environment:
      REDIS_PASSWORD: ${APP_REDIS_PASSWORD}
      REDIS_PORT: ${APP_REDIS_PORT}
networks:
  backend:
    name: backend
    driver: bridge
volumes:
  mysql:
  redis:
```

And main file `docker-compose.yml`:
```yaml
version: "3.7"

services:
  nginx:
    container_name: ${APP_COMPOSE_PROJECT_NAME}_nginx
    build:
      context: ./.docker/nginx
    networks:
      - backend
    working_dir: /app
    volumes:
      - ./:/app
    ports:
      - '${APP_PORT:-9505}:80'
  php-fpm:
    container_name: ${APP_COMPOSE_PROJECT_NAME}_php_fpm
    build:
      context: ./.docker/php${PHP_VER}-${APP_ENV}
    networks:
      - backend
    env_file:
      - .env
    user: ${UID:-1000}:${GID:-1000}
    extra_hosts:
      - 'host.docker.internal:host-gateway'
    volumes:
      - ~/.composer/cache/:/.composer_cache/:rw
      - ./:/app:rw
    working_dir: /app

  tasks:
    container_name: ${APP_COMPOSE_PROJECT_NAME}_tasks
    build:
      context: ./.docker/php${PHP_VER}-${APP_ENV}-cli
    networks:
      - backend
    env_file:
      - .env
    user: ${UID:-1000}:${GID:-1000}
    extra_hosts:
      - 'host.docker.internal:host-gateway'
    volumes:
      - ./:/app:rw
    working_dir: /app
    restart: always
    command: '/usr/bin/supervisord'

networks:
  backend:
    name: backend
    driver: bridge
```

In this case, you can use `make shared-service-start` to start shared services and `make shared-service-stop` to stop shared services.
or simple command `make start-all` to start all services.

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
