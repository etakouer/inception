#!/bin/bash

service mariadb start > /dev/null 2>&1 
echo "$(envsubst < /tmp/init.sql)" > /tmp/init.sql
mariadb < /tmp/init.sql
service mariadb stop > /dev/null 2>&1 
exec $@
