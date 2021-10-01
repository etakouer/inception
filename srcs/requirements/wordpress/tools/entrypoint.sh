#!/bin/bash

# test if wp not already installed
if ! test -f "/var/www/${DOMAIN_NAME}/index.php";
then

  cd ${WP_SRC}
  # create wp-config.php
  wp config create --dbhost="${WORDPRESS_DB_HOST}" --dbname="${WORDPRESS_DB_NAME}" --dbuser="${WORDPRESS_DB_USER}" --dbpass="${WORDPRESS_DB_PASSWORD}" --dbprefix="wp_" --allow-root --skip-check

  # configure wordpress
  wp core install --url="https://${DOMAIN_NAME}/" --title="${WP_TITLE}" --admin_name="${WP_ADMIN_LOG}" --admin_email="${WP_ADMIN_EMAIL}" --admin_password="${WP_ADMIN_PASS}" --skip-email --allow-root
  
  # add an editor
  wp user create "${WP_EDITOR_LOG}" "${WP_EDITOR_EMAIL}" --role="editor" --user_pass="${WP_EDITOR_PASS}" --allow-root

  # add redis plugin
  wp config --allow-root set ENABLE_CACHE true --raw
  wp config --allow-root set WP_REDIS_PORT 6379 --raw
  wp config --allow-root set WP_REDIS_HOST redis --raw
  wp plugin install redis-cache --activate --allow-root

  # allow rw for www-data
  cp -r ${WP_SRC}/* /var/www/${DOMAIN_NAME}/
  mkdir /var/www/${DOMAIN_NAME}/wp-content/cache 
  chown -R www-data:www-data /var/www/${DOMAIN_NAME}
  chmod 777 /var/www/${DOMAIN_NAME}
fi

# start php-fpm deamon
mkdir -p /run/php
exec $(eval echo "$@")
