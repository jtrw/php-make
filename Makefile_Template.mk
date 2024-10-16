## --- ✅ Main Makefile ----------------------------------------------------
$(shell (if [ ! -e .env ]; then cp .env.default .env; fi))
include .env
export

RUN_ARGS = $(filter-out $@,$(MAKECMDGOALS))

include vendor/jtrw/php-make/.make/utils.mk
include vendor/jtrw/php-make/.make/colours.mk
include vendor/jtrw/php-make/.make/docker-compose-shared-services.mk
include vendor/jtrw/php-make/.make/composer.mk
include vendor/jtrw/php-make/.make/static-analysis.mk
include vendor/jtrw/php-make/.make/migrations-symfony.mk

.PHONY: install
install: ##up-services ## install up environment
	docker-compose up -d --build

.PHONY: start
start: ##up-services ## spin up environment
	docker-compose up -d

.PHONY: stop
stop: ## stop environment
	docker-compose stop

.PHONY: start-services
start-services: shared-service-start ## up shared services

.PHONY: stop-services
stop-services: shared-service-stop ## stop-shared-services

.PHONY: start-all
start-all: start start-services ## start full project environment

.PHONY: stop-all
stop-all: stop stop-services ## stop full project environment

.PHONY: php-shell
php-shell: ## PHP shell
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -l






