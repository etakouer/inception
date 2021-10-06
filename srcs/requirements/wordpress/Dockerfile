FROM debian:buster

MAINTAINER etakouer <etakouer@student.42nice.fr>

ARG DOMAIN_NAME
ARG PHP_V
ARG WP_V
ARG WP_SRC

# update repository
RUN apt-get -y update && \
apt-get -y install apt-transport-https lsb-release ca-certificates wget && \
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
apt-get -y update

# install
RUN apt-get -y install php$PHP_V-fpm && \
apt-get -y install php$PHP_V-bcmath php$PHP_V-bz2 php$PHP_V-curl php$PHP_V-intl php$PHP_V-mbstring php$PHP_V-mysql php$PHP_V-readline php$PHP_V-xml php$PHP_V-zip && \
apt-get -y install gettext-base && \
apt-get clean -y

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
chmod +x wp-cli.phar && \
mv wp-cli.phar /usr/local/bin/wp && \
wp core download --locale=fr_FR --version=$WP_V --path=$WP_SRC --allow-root

WORKDIR /var/www/$DOMAIN_NAME 

COPY tools/entrypoint.sh /usr/bin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm$PHP_V","-F","-R"]
