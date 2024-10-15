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

.PHONY: console
console: ## execute symfony console command
	docker-compose run --rm php sh -lc "./bin/console $(RUN_ARGS)"

.PHONY: logs
logs: ## look for service logs
	docker-compose logs -f $(RUN_ARGS)

.PHONY: docker-stop
docker-stop: ## stop all containers
	$(eval CONTAINERS=$(shell (docker ps -q)))
	@$(if $(strip $(CONTAINERS)), echo Going to stop all containers: $(shell docker stop $(CONTAINERS)), echo No run containers)

.PHONY: docker-remove
docker-remove: ## remove all containers
	$(eval CONTAINERS=$(shell (docker ps -aq)))
	@$(if $(strip $(CONTAINERS)), echo Going to remove all containers: $(shell docker rm $(CONTAINERS)), echo No containers)

.PHONY: docker-remove-volumes
docker-remove-volumes: ## remove project docker vo
	$(eval VOLUMES = $(shell (docker volume ls --filter name=$(CUR_DIR) -q)))
	$(if $(strip $(VOLUMES)), echo Going to remove volumes $(shell docker volume rm $(VOLUMES)), echo No active volumes)

.PHONY: docker-remove-images
docker-remove-images: ## remove all images
	$(eval IMAGES=$(shell (docker images -q)))
	@$(if $(strip $(IMAGES)), echo Going to remove all images: $(shell docker rmi $(IMAGES)), echo No images)

.PHONY: docker-update
docker-update: docker-stop docker-remove docker-remove-images build ## update all project containers
