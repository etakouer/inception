GREEN = "\033[32m"
WHITE = "\033[0m"

define print
	echo -e $(GREEN)$(1)$(WHITE)
endef

DOMAIN = etakouer.42.fr static-site.42.fr dynamic-site.42.fr
DATA_DIR = ${HOME}/data

_C = docker ps -aq
_I = docker images -aq
_V = docker volume ls -q
_N = docker network ls -q
 
NB_C = $$($(_C) | wc -l)
NB_I = $$($(_I) | wc -l)
NB_V = $$($(_V) | wc -l)
NB_N = $$($(_N) | wc -l)

clean	: SHELL:=/bin/bash
fclean	: SHELL:=/bin/bash
all	: SHELL:=/bin/bash
dclean	: SHELL:=/bin/bash
up	: SHELL:=/bin/bash
build	: SHELL:=/bin/bash
install	: SHELL:=/bin/bash
init	: SHELL:=/bin/bash

all     : dclean clean build up

install :
	@$(call print,"- Install docker")
	sudo apt-get remove docker docker-engine docker.io containerd runc
	sudo apt-get -y update
	sudo apt-get -y install \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
	lsb-release
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo \
  	"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get -y update
	sudo apt-get -y install docker-ce docker-ce-cli containerd.io
	@$(call print,"- Install docker compose")
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
	-o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

init 	:
	@echo "- Create ${DATA_DIR}/mysql/"
	@mkdir -p  ${DATA_DIR}/mysql/
	@echo "- Create ${DATA_DIR}/log/nginx/"
	@mkdir -p  ${DATA_DIR}/log/nginx/
	@echo "- Create ${DATA_DIR}/redis/"
	@mkdir -p  ${DATA_DIR}/redis/
	@for d in $(DOMAIN); do echo "- Create ${DATA_DIR}/www/$$d/"; mkdir -p  ${DATA_DIR}/www/$$d ; done
	@echo "- Give permission to ${DATA_DIR}/www"
	@sudo chown -R www-data:www-data ${DATA_DIR}/www ; sudo chmod -R 777 ${DATA_DIR}/www 
	@echo "- Add domain names in /etc/hosts :"
	@for d in $(DOMAIN); do echo " 127.0.0.1 $$d"; grep "$$d" /etc/hosts > /dev/null || sudo bash -c "echo '127.0.0.1	$$d' >> /etc/hosts"; true; done

up     	:
	@$(call print,"- Docker-compose Up")
	@cd srcs && docker-compose up -d 

build   : 
	@$(call print,"- Docker-compose build")
	@cd srcs && docker-compose build

clean   : 
	@$(call print,"- Clean containers")
	@[ $(NB_C) -ne 0 ] && docker rm -f $$($(_C)); true
	@$(call print,"- Clean volumes")
	@[ $(NB_V) -ne 0 ] && docker volume rm -f $$($(_V)); true
	@$(call print,"- Clean networks")
	@[ $(NB_N) -ne 0 ] && docker network rm $$($(_N)) 2> /dev/null ; true

fclean  : dclean clean
	@$(call print,"- Clean images")
	@[ $(NB_I) -ne 0 ] && docker rmi -f $$($(_I)); true

dclean  :
	@$(call print,"- Clean data (mysql, wordpress, nginx logs, redis cache)")
	@sudo rm -rf /data/mysql/*
	@sudo rm -rf /data/www/etakouer.42.fr/*
	@sudo rm -rf /data/log/nginx/*
	@sudo rm -rf /data/redis/*

re	: fclean all

.PHONY: all clean fclean re
