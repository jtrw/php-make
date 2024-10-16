## --- 🔨 Utils --------------------------------------------------
sources = bin/console config src
version = $(shell git describe --tags --dirty --always)
build_name = application-$(version)
# use the rest as arguments for "run"
#RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
# ...and turn them into do-nothing targets
#$(eval $(RUN_ARGS):;@:)

# Default parallelism
#JOBS=$(shell nproc)

.PHONY: fix-permission
fix-permission: ## fix permission for docker env
	echo chown -R $(shell whoami):$(shell whoami) *
	echo chown -R $(shell whoami):$(shell whoami) .docker/*
	echo chmod +x ./bin/console

wait:
ifeq ($(OS),Windows_NT)
	timeout 15
else
	sleep 15
endif

.DEFAULT_GOAL := help
.PHONY: help
help: ## Display this help message
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: help2
help2: ## print this help message
	@cat $(MAKEFILE_LIST) | grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'| sed -e 's/\[32m##/[33m/'

.PHONY: console
console: ## execute symfony console command
	docker-compose run --rm php sh -lc "./bin/console $(RUN_ARGS)"
