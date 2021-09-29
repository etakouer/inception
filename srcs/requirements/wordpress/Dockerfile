FROM debian:buster

MAINTAINER etakouer <etakouer@student.42nice.fr>

# update repository
RUN apt-get -y update && \
apt-get -y install apt-transport-https lsb-release ca-certificates wget && \
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
apt-get -y update

# install
RUN apt-get -y install php7.4-fpm && \
apt-get -y install php7.4-bcmath php7.4-bz2 php7.4-curl php7.4-intl php7.4-mbstring php7.4-mysql php7.4-readline php7.4-xml php7.4-zip && \
apt-get -y install gettext-base && \
apt-get clean -y

# wordpress
RUN cd /usr/src && \
wget https://wordpress.org/wordpress-5.8.1.tar.gz && \
tar xzf wordpress-5.8.1.tar.gz && \
rm wordpress-5.8.1.tar.gz

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
chmod +x wp-cli.phar && \
mv wp-cli.phar /usr/local/bin/wp

COPY conf/wp-config.php /usr/src/wordpress

EXPOSE 9000

COPY tools/entrypoint.sh /usr/bin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm7.4","-F","-R"]
