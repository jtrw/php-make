## --- 🛠️ Shared Services ----------------------------------------------------
ifeq ($(OS),Windows_NT)
    CWD := $(lastword $(dir $(realpath $(MAKEFILE_LIST)/../)))
else
    CWD := $(abspath $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST))))/../))/
endif

shared-service-start: ## up shared services
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml up -d

shared-service-erase: ## down shared services
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml stop
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml down -v --remove-orphans

shared-service-stop: ## stop-shared-services
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml stop

shared-service-logs: ## logs-shared-services
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml logs -f
