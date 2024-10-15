ifeq ($(OS),Windows_NT)
    CWD := $(lastword $(dir $(realpath $(MAKEFILE_LIST)/../)))
else
    CWD := $(abspath $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))/../))/
endif

shared-service-start:
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml up -d

shared-service-erase:
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml stop
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml down -v --remove-orphans

shared-service-stop:
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml stop

shared-service-logs:
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml logs -f

shared-service-setup-db:
	docker-compose --project-directory $(CWD) -f $(CWD)docker-compose.yml exec mariadb sh /tmp/initdb/simple-db.sh