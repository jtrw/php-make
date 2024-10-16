## --- 🙆 Composer ----------------------------------------------------
.PHONY: composer-install
composer-install: ## Install project dependencies
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc 'composer install --ignore-platform-reqs'

.PHONY: composer-update
composer-update: ## Update project dependencies
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc 'composer update --no-cache --ignore-platform-reqs'

.PHONY: composer-outdated
composer-outdated: ## Show outdated project dependencies
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc 'composer outdated'

.PHONY: composer-validate
composer-validate: ## Validate composer config
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc 'composer validate --no-check-publish'

.PHONY: composer
composer: ## Execute composer command
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "composer $(RUN_ARGS)"
