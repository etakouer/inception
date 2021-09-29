#!/bin/bash

if ! test -f "/var/www/etakouer.42.fr/index.php";
then
  format=$(env | awk -F '=' '/WORDPRESS/ {printf "${%s} ",$1}')
  envsubst "${format}" < /usr/src/wordpress/wp-config.php > /usr/src/wordpress/wp-config-sample.php
  mv /usr/src/wordpress/wp-config-sample.php /usr/src/wordpress/wp-config.php 
  cp -r /usr/src/wordpress/* /var/www/etakouer.42.fr/
  chown -R www-data:www-data /var/www/etakouer.42.fr
  chmod 777 /var/www/etakouer.42.fr
fi
mkdir -p /run/php
exec $@
