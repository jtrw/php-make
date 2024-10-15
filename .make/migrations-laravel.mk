ifeq ($(APP_ENV),$(filter $(APP_ENV),production))
	IS_PROD = true
endif

.PHONY: migration-create
migration-create: ## Create new migration for Laravel
	docker-compose run --rm $(PHP_FPM_NAME) php artisan make:migration $(RUN_ARGS)

.PHONY: migration-migrate
migration-migrate: ## Execute all available migrations for Laravel
ifdef IS_PROD
	docker-compose run --rm $(PHP_FPM_NAME) php artisan migrate --force
else
	docker-compose run --rm $(PHP_FPM_NAME) php artisan migrate
endif

.PHONY: migration-seed
migration-seed: ## Seed database with records for Laravel
ifdef IS_PROD
	docker-compose run --rm $(PHP_FPM_NAME) php artisan db:seed --force
else
	docker-compose run --rm $(PHP_FPM_NAME) php artisan db:seed

.PHONY: migration-list
migration-list: ## Get list of migration with statuses and execution statistics for Laravel
	docker-compose run --rm $(PHP_FPM_NAME) php artisan migrate:status

.PHONY: migration-status
migration-status: ## Returns table with migration statuses for Laravel
	docker-compose run --rm $(PHP_FPM_NAME) php artisan migrate:status

.PHONY: migration-rollback
migration-rollback: ## Executes migration with target: --step=1, --batch=1, --pretend for Laravel
	docker-compose run --rm $(PHP_FPM_NAME) php artisan migrate:rollback $(RUN_ARGS)
