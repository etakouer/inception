FROM debian:buster

MAINTAINER etakouer <etakouer@student.42nice.fr>

ARG ADMINER_V
ARG PHP_V

# update repository
RUN apt-get -y update && \
apt-get -y install apt-transport-https lsb-release ca-certificates wget && \
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
apt-get -y update

# install php
RUN apt-get -y install php$PHP_V-fpm && \
apt-get -y install php$PHP_V-bcmath php$PHP_V-bz2 php$PHP_V-curl php$PHP_V-intl php$PHP_V-mbstring php$PHP_V-mysql php$PHP_V-readline php$PHP_V-xml php$PHP_V-zip && \
apt-get -y install gettext-base && \
apt-get clean -y

RUN mkdir -p /var/www/html && \
cd /var/www/html && \
wget https://github.com/vrana/adminer/releases/download/v$ADMINER_V/adminer-$ADMINER_V.php -O index.php

EXPOSE 8080

WORKDIR /var/www/html

CMD ["php","-S","0.0.0.0:8080"]
