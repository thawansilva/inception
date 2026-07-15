-include ./srcs/.env

export

COMPOSE_FILE=srcs/docker-compose.yml

all: up

volumes:
	mkdir -p $(VOLUME_MARIADB) $(VOLUME_WORDPRESS) $(VOLUME_REDIS) $(VOLUME_PORTAINER)

up: volumes
	docker compose -f $(COMPOSE_FILE) up -d

down:
	docker compose -f $(COMPOSE_FILE) down

clean: down
	docker volume prune -a -f

fclean: clean
	docker image prune -a -f
	sudo rm -fr $(VOLUME_MARIADB) $(VOLUME_WORDPRESS) $(VOLUME_REDIS) $(VOLUME_PORTAINER)

re: fclean all

.PHONY: all down clean fclean re
