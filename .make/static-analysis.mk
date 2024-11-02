## --- 📘 Static analysis --------------------------------------------------
.PHONY: lint layer style coding-standards
static-analysis: lint layer style coding-standards ## Run phpstan, deprac, easycoding standarts code static analysis

.PHONY: phpstan phan psalm
style: phpstan phan psalm ## executes php analizers

.PHONY: lint
lint: ## checks syntax of PHP files
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'./vendor/bin/parallel-lint ./ --exclude vendor --exclude bin/.phpunit') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"
	#docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc './bin/console lint:yaml config'

.PHONY: layer
layer: ## check issues with layers (deptrac tool)
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'./vendor/bin/deptrac analyze --formatter-graphviz=0') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"

.PHONY: coding-standards
coding-standards: ## run check and validate code standards tests
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'./vendor/bin/ecs check src tests') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"
#	docker-compose run --rm --no-deps php sh -lc './vendor/bin/phpmd src/ text phpmd.xml' #todo: uncomment when phpmd supports php8.0

.PHONY: coding-standards-fixer
coding-standards-fixer: ## run code standards fixer
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'./vendor/bin/ecs check src tests --fix') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"

tests-unit: ## Run unit-tests suite
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'vendor/bin/phpunit --configuration /app/phpunit.xml.dist') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"

tests-integration: ## Run integration-tests suite
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'vendor/bin/phpunit --configuration /app/phpunit.func.xml') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"

.PHONY: infection
infection: ## executes mutation framework infection
	CMD = $(if $(RUN_ARGS),$(RUN_ARGS),'./vendor/bin/infection --min-msi=70 --min-covered-msi=80 --threads=$(JOBS) --coverage=var/report') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"

.PHONY: phpstan
phpstan: ## phpstan - PHP Static Analysis Tool
	CMD=$(if $(RUN_ARGS),$(RUN_ARGS),'./vendor/bin/phpstan analyse -l 6 -c phpstan.neon src tests') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"

.PHONY: psalm
psalm: ## psalm is a static analysis tool for finding errors in PHP applications
	CMD = $(if $(RUN_ARGS),$(RUN_ARGS),'./vendor/bin/psalm --config=psalm.xml') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"

.PHONY: phan
phan: ## phan is a static analyzer for PHP that prefers to minimize false-positives.
	CMD = $(if $(RUN_ARGS),$(RUN_ARGS),'PHAN_DISABLE_XDEBUG_WARN=1 PHAN_ALLOW_XDEBUG=0 php -d zend.enable_gc=0 ./vendor/bin/phan --config-file .phan/config.php --require-config-exists') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"

.PHONY: security-tests
security-tests: ## The SensioLabs Security Checker
	CMD = $(if $(RUN_ARGS),$(RUN_ARGS),'./vendor/bin/security-checker security:check') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"


.PHONY: code-coverage
code-coverage: ## Pcov code coverage
	CMD = $(if $(RUN_ARGS),$(RUN_ARGS),'php -dpcov.enabled=1 -dpcov.directory=. -dpcov.exclude="~vendor~" ./vendor/bin/phpunit --coverage-text') && \
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "$$CMD"

.PHONY: phpcs
phpcs: ## Check style by phpcs. Use --ignore to exclude directories from check (e.g. make phpcs --ignore='src/IgnoreModule') --standard to set ruleset (e.g. make phpcs --standard=.rule/ruleset.xml)
	docker-compose run --rm --no-deps $(PHP_FPM_NAME) sh -lc "./vendor/bin/phpcs $(RUN_ARGS)"

