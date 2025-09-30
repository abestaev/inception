DOCKER_COMPOSE ?= docker compose
DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

DATA_DIR = /home/albestae/data
MYSQL_DIR = $(DATA_DIR)/mysql
WORDPRESS_DIR = $(DATA_DIR)/wordpress
REDIS_DIR = $(DATA_DIR)/redis
MINECRAFT_DIR = $(DATA_DIR)/minecraft

.PHONY: all build up down restart clean fclean logs ssl status test

all: build

build:
	mkdir -p $(MYSQL_DIR)
	mkdir -p $(WORDPRESS_DIR)
	mkdir -p $(REDIS_DIR)
	mkdir -p $(MINECRAFT_DIR)
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up --build -d

up:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d

down:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down

restart: down up

clean:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
	docker system prune -a --volumes -f

logs:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) logs -f

ssl:
	@echo "🔐 SSL certificates are generated automatically during build"
	@echo "📝 To use custom certificates, place them in:"
	@echo "   - Certificate: ./srcs/requirements/nginx/ssl/cert.crt"
	@echo "   - Private key: ./srcs/requirements/nginx/ssl/key.key"

status:
	@echo "📊 Container Status:"
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) ps
	@echo ""
	@echo "🌐 Services accessible at:"
	@echo "   - HTTP:  http://albestae.42.fr (redirects to HTTPS)"
	@echo "   - HTTPS: https://albestae.42.fr"
	@echo "   - MariaDB: localhost:3306 (localhost only)"

test:
	@echo "🧪 Test de configuration..."
	cd srcs && ./test-config.sh
