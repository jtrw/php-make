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
