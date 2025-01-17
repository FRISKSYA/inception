NAME = inception

DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

all: up

up:
	@printf "Starting ${NAME} containers...\n"
	@docker-compose -f ${DOCKER_COMPOSE_FILE} up --build -d

down:
	@printf "Stopping ${NAME} containers...\n"
	@docker-compose -f ${DOCKER_COMPOSE_FILE} down

start:
	@printf "Starting ${NAME} containers...\n"
	@docker-compose -f ${DOCKER_COMPOSE_FILE} start

stop:
	@printf "Stopping ${NAME} containers...\n"
	@docker-compose -f ${DOCKER_COMPOSE_FILE} stop

# クリーンアップ用のターゲット
clean: down
	@printf "Cleaning up ${NAME} containers...\n"
	@docker system prune -a

fclean: clean
	@printf "Force cleaning everything...\n"
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf ~/data/wordpress/* 2>/dev/null || true
	@sudo rm -rf ~/data/mariadb/* 2>/dev/null || true

# 開発用のユーティリティターゲット
re: fclean all

ps:
	@docker-compose -f ${DOCKER_COMPOSE_FILE} ps

logs:
	@docker-compose -f ${DOCKER_COMPOSE_FILE} logs

.PHONY: all up down start stop clean fclean re ps logs