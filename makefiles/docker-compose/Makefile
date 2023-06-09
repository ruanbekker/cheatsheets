# Thanks: https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db
.PHONY: help

HAS_DOCKER_COMPOSE := $(shell command -v docker-compose 2> /dev/null)
HAS_DOCKER_COMPOSE_V2 := $(shell command -v docker 2> /dev/null)

ifeq ($(strip $(HAS_DOCKER_COMPOSE)),)
    ifeq ($(strip $(HAS_DOCKER_COMPOSE_V2)),)
        $(error No compatible command found)
    else
        DOCKER_COMPOSE_BINARY := docker compose
    endif
else
    DOCKER_COMPOSE_BINARY := docker-compose
endif

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
up: ## Runs the containers in detached mode
	@$(DOCKER_COMPOSE_BINARY) up -d --build

clean: ## Stops and removes all containers
	@$(DOCKER_COMPOSE_BINARY) down

logs: ## View the logs from the containers
	@$(DOCKER_COMPOSE_BINARY) logs -f

open: ## Opens tabs in container
	open http://localhost:3000/
