DOCKER_COMPOSE = docker compose
DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

DATA_DIR = $(HOME)/data
MYSQL_DIR = $(DATA_DIR)/mysql
WORDPRESS_DIR = $(DATA_DIR)/wordpress

.PHONY: all build up down restart clean fclean logs

all: build

build:
	mkdir -p $(MYSQL_DIR)
	mkdir -p $(WORDPRESS_DIR)
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up --build -d

up:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d

down:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down

restart: down up

clean:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
	rm -rf $(MYSQL_DIR)
	rm -rf $(WORDPRESS_DIR)
	docker system prune -a --volumes -f

logs:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) logs -f
