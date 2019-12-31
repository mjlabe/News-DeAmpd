CONTAINER_NAME:=news

.DEFAULT_GOAL := build

CONTEXT:=default

.PHONY: shell
shell:
	docker-compose run $(CONTAINER_NAME) bash

.PHONY: build
build:
	docker build -t $(CONTAINER_NAME) .

### DEPLOYMENT ================================================================

# The current git hash
TAG:=$(shell git log -1 --pretty=format:"%H")
NETWORK_HASH:=$(shell openssl rand -hex 6)

# Command line arguments w/ defaults
environment ?= latest

# 1 day in seconds
CACHE_CONTROL_MAX:=86400

### HELPER TARGETS ============================================================
### These are better for quickly running things and greatly reduce typing.

.PHONY: run
run:
	docker-compose stop
	docker-compose up

.PHONY: makemigrations
makemigrations:
	docker-compose run --rm $(CONTAINER_NAME) ./manage.py makemigrations

.PHONY: migrate
migrate:
	docker-compose run --rm $(CONTAINER_NAME) ./manage.py migrate

.PHONY: lint
lint:
	docker-compose run --rm $(CONTAINER_NAME) pylint apps

.PHONY: test
test:
	docker-compose run --rm $(CONTAINER_NAME) ./manage.py test
