## -- 🛢️ Migrations for Symfony -------------------------------------------------
ifeq ($(APP_ENV),$(filter $(APP_ENV),prod))
	IS_PROD = true
endif

.PHONY: migration-create
migration-create: ## Create new migration
	docker-compose run --rm $(PHP_FPM_NAME) php bin/console doctrine:migrations:generate

.PHONY: migration-migrate
migration-migrate: ## Execute all available migrations
ifdef IS_PROD
	docker-compose run --rm $(PHP_FPM_NAME) php bin/console doctrine:migrations:migrate --no-interaction
else
	docker-compose run --rm $(PHP_FPM_NAME) php bin/console doctrine:migrations:migrate
endif

.PHONY: migration-list
migration-list: ## Get list of migration with statuses and execution statistics
	docker-compose run --rm $(PHP_FPM_NAME) php bin/console doctrine:migrations:list

.PHONY: migration-status
migration-status: ## Returns table with migration statuses
	docker-compose run --rm $(PHP_FPM_NAME) php bin/console doctrine:migrations:status

.PHONY: migration-rollback
migration-rollback: ## Executes migration with target: next, prev, first
	docker-compose run --rm $(PHP_FPM_NAME) php bin/console doctrine:migrations:migrate $(RUN_ARGS)

.PHONY: migration-database-create
migration-database-create: ## Creating database
ifdef IS_PROD
	@echo "$(C_RED)You can run this command only in develop mode$(C_END)"
else
	docker-compose run --rm $(PHP_FPM_NAME) php bin/console doctrine:database:create
endif

.PHONY: migration-database-drop
migration-database-drop: ## Drop current database
ifdef IS_PROD
	@echo "$(C_RED)You can run this command only in develop mode$(C_END)"
else
	docker-compose run --rm $(PHP_FPM_NAME) php bin/console doctrine:database:drop --force
endif

.PHONY: migration-refresh-database
migration-refresh-database: ## Drop current schema and creates new with fresh migration
ifdef IS_PROD
	@echo "$(C_RED)You can run this command only in develop mode$(C_END)"
else
	make migration-database-drop
	@echo "$(C_RED) --- Databse droped --- $(C_END)"
	make migration-database-create

	@echo "$(C_GREEN) --- New databse created --- $(C_END)"
	make migration-migrate
	@echo "$(C_GREEN) --- Migrated --- $(C_END)"
endif
