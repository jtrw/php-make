.PHONY: test-service-build
test-service-build: ## Build test DB
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-test-env.yml up -d --build

.PHONY: test-service-start
test-service-start: ## Start test services
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-test-env.yml up -d

.PHONY: test-service-stop
test-service-stop: ## Stop test services
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-test-env.yml stop

.PHONY: migration-test-db
migration-test-db: ## Migrate Test DB
	docker-compose -f $(CWD)/docker-compose-test-env.yml run --rm --no-deps crm_tests sh -lc "php bin/console doctrine:database:drop --force && php bin/console doctrine:database:create && php bin/console doctrine:migrations:migrate --no-interaction"

.PHONY: create-tests-db
create-tests-db: ## Create Test DB
	docker-compose -f $(CWD)/docker-compose-test-env.yml run --rm --no-deps crm_tests sh -lc "php bin/console doctrine:database:drop --force && php bin/console doctrine:database:create && php bin/console doctrine:migrations:migrate --no-interaction && php bin/phpunit -c tests/phpunit.xml"

.PHONY: run-tests
run-tests:
	docker-compose -f $(CWD)/docker-compose-test-env.yml run --rm --no-deps crm_tests sh -lc "php bin/phpunit -c tests/phpunit.xml --testdox --stderr --colors"

.PHONY: tests
tests: migration-test-db run-tests

.PHONY: testsuite
testsuite:
	docker-compose -f $(CWD)/docker-compose-test-env.yml run --rm --no-deps crm_tests sh -lc "php bin/phpunit -c tests/phpunit.xml --testsuite $(RUN_ARGS)"
