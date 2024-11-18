## --- 📘 Static analysis --------------------------------------------------
.PHONY: lint layer style coding-standards
static-analysis: lint layer style coding-standards ## Run phpstan, deprac, easycoding standarts code static analysis

.PHONY: phpstan phan psalm
style: phpstan phan psalm ## executes php analizers

.PHONY: lint
lint: ## checks syntax of PHP files
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'./ --exclude vendor --exclude bin/.phpunit') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "./vendor/bin/parallel-lint $$CMD"
	#docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc './bin/console lint:yaml config'

.PHONY: layer
layer: ## check issues with layers (deptrac tool). Use param args to set ruleset (e.g. make layer args='--formatter-graphviz=0')
	CMD=$(if $(args),$(args),'--formatter-graphviz=0') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "./vendor/bin/deptrac analyze $$CMD"

.PHONY: coding-standards
coding-standards: ## run check and validate code standards tests
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'src tests') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "./vendor/bin/ecs check $$CMD"
#	docker-compose run --rm --no-deps php sh -lc './vendor/bin/phpmd src/ text phpmd.xml' #todo: uncomment when phpmd supports php8.0

.PHONY: coding-standards-fixer
coding-standards-fixer: ## run code standards fixer
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'src tests --fix') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "./vendor/bin/ecs check $$CMD"

tests-unit: ## Run unit-tests suite. Use param args to set ruleset (e.g. make tests-unit args='--configuration phpunit.xml.dist')
	CMD=$(if $(args),$(args),'--configuration phpunit.xml.dist') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "vendor/bin/phpunit $$CMD"

tests-integration: ## Run integration-tests suite. Use param args to set ruleset (e.g. make tests-integration args='--configuration phpunit.func.xml')
	CMD=$(if $(args),$(args),'--configuration phpunit.func.xml') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "vendor/bin/phpunit $$CMD"

.PHONY: infection
infection: ## executes mutation framework infection. Use param args to set ruleset (e.g. make infection args='--min-msi=70 --min-covered-msi=80 --threads=$(JOBS) --coverage=var/report')
	CMD=$(if $(args),$(args),'--min-msi=70 --min-covered-msi=80 --threads=$(JOBS) --coverage=var/report') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "./vendor/bin/infection $$CMD"

.PHONY: phpstan
phpstan: ## phpstan - PHP Static Analysis Tool
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'src/') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "./vendor/bin/phpstan analyse $$CMD"

.PHONY: psalm
psalm: ## psalm is a static analysis tool for finding errors in PHP applications. Use param args to set ruleset (e.g. make psalm args='--config=psalm.xml')
	CMD=$(if $(args),$(args),'--config=psalm.xml') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "./vendor/bin/psalm $$CMD"

.PHONY: phan
phan: ## phan is a static analyzer for PHP that prefers to minimize false-positives. Use param args to set ruleset (e.g. make phan args='--config-file .phan/config.php --require-config-exists')
	CMD=$(if $(args),$(args),'--config-file .phan/config.php --require-config-exists') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "PHAN_DISABLE_XDEBUG_WARN=1 PHAN_ALLOW_XDEBUG=0 php -d zend.enable_gc=0 ./vendor/bin/phan $$CMD"

.PHONY: security-tests
security-tests: ## The SensioLabs Security Checker
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'./vendor/bin/security-checker security:check') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"


.PHONY: code-coverage
code-coverage: ## Pcov code coverage
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'php -dpcov.enabled=1 -dpcov.directory=. -dpcov.exclude="~vendor~" ./vendor/bin/phpunit --coverage-text') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"

.PHONY: phpcs
phpcs: ## Check style by phpcs. Use param args to set ruleset (e.g. make phpcs args='--standard=.rule/ruleset.xml')
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "./vendor/bin/phpcs $(args)"

