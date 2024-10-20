# PHP Make

Useful PHP Makefile for PHP projects.
Simple collections of make commands to increase productivity.
In this project I collect useful commands for PHP projects. Most of the commands are related to Docker projects.

## Install

1. `./vendor/bin/php-make` for copy template Makefile to your project if Makefile exists it will be not overwritten.
2. If you use your own Makefile, you can add the following line to your Makefile:
```makefile
include .make/utils.mk
include .make/colours.mk
include .make/docker-compose-shared-services.mk
include .make/composer.mk
include .make/static-analysis.mk
include .make/migrations-symfony.mk
```
3. Add to your .env file variable `PHP_FPM_NAME` and `APP_ENV` for example:
```dotenv
PHP_FPM_NAME=php-fpm
APP_ENV=dev
```
4. Use `make help` to see all available commands.

## Usage

image: ![make help](/docs/make-help.jpg)

### composer.mk

File `composer.mk` contains commands for composer.

#### composer-install
```shell
make composer-install
```



## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
