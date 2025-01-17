NAME = inception

# Dockerコンポーズの設定ファイル
DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

# データディレクトリのパス
DATA_PATH = /home/$(USER)/data

# コンテナ操作用のターゲット
all: setup up

# セットアップ用のターゲット
setup:
	@printf "Setting up directories for ${NAME}...\n"
	@sudo mkdir -p ${DATA_PATH}/mariadb
	@sudo mkdir -p ${DATA_PATH}/wordpress
	@sudo mkdir -p ${DATA_PATH}/nginx
	@sudo chmod 777 ${DATA_PATH}/mariadb
	@sudo chmod 777 ${DATA_PATH}/wordpress
	@sudo chmod 777 ${DATA_PATH}/nginx

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
	@sudo rm -rf ${DATA_PATH}/wordpress/* 2>/dev/null || true
	@sudo rm -rf ${DATA_PATH}/mariadb/* 2>/dev/null || true
	@sudo rm -rf ${DATA_PATH}/nginx/* 2>/dev/null || true

# 開発用のユーティリティターゲット
re: fclean all

ps:
	@docker-compose -f ${DOCKER_COMPOSE_FILE} ps

logs:
	@docker-compose -f ${DOCKER_COMPOSE_FILE} logs

.PHONY: all setup up down start stop clean fclean re ps logs