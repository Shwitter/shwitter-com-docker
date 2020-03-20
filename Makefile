-include .env

.PHONY: up down stop prune ps shell  logs setup setdev setprod go 

default: up

## DOCKER
up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --remove-orphans

down: stop

stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose stop

prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose down -v

ps:
	@docker ps --filter name='$(PROJECT_NAME)*'

shell-api:
	@docker exec -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='shwitter.api' --format "{{ .ID }}") sh

shell-front:
	@docker exec -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='shwitter.frontend' --format "{{ .ID }}") sh

logs:
	@docker-compose logs -f $(filter-out $@,$(MAKECMDGOALS))

install:
	./scripts/install.sh

front-start:
	docker exec -it --user node shwitter.frontend npm start

api-start:
	docker exec -it --user node shwitter.api npm run dev
