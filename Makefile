GREEN = "\033[32m"
WHITE = "\033[0m"

define print
	echo -e $(GREEN)$(1)$(WHITE)
endef

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

all     : dclean clean build up

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
	@$(call print,"- Clean data (mysql, wordpress, nginx logs)")
	@sudo rm -rf /data/mysql/*
	@sudo rm -rf /data/www/etakouer.42.fr/*
	@sudo rm -rf /data/log/nginx/*

re	: fclean all

.PHONY: all clean fclean re
