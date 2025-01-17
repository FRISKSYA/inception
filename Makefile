NAME = inception

all: setup up

setup:
	@mkdir -p /home/${USER}/data/mariadb

up:
	@docker-compose -f srcs/docker-compose.yml up -d

down:
	@docker-compose -f srcs/docker-compose.yml down

stop:
	@docker-compose -f srcs/docker-compose.yml stop

clean:
	@docker system prune -a

fclean: down clean
	@if [ $$(docker volume ls -q | wc -l) -gt 0 ]; then \
		docker volume rm $$(docker volume ls -q) || true; \
	fi
	@sudo rm -rf /home/${USER}/data/mariadb/*    # ディレクトリ自体は残し、中身だけを削除
	@sudo rmdir /home/${USER}/data/mariadb /home/${USER}/data 2>/dev/null || true  # ディレクトリが空の場合のみ削除

status:
	@docker ps

re: fclean all

.PHONY: all setup up down stop clean fclean status re