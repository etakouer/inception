FROM debian:buster

MAINTAINER etakouer <etakouer@student.42nice.fr>

ARG MARIADB_V

# update repository
RUN apt-get -y update && \
apt-get -y install software-properties-common gnupg2 && \
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8 && \
add-apt-repository "deb [arch=amd64] http://mariadb.mirror.liquidtelecom.com/repo/10.6/debian $(lsb_release -cs) main" && \
apt-get -y update

# install
RUN apt-get -y install mariadb-server=1:$MARIADB_V+maria~buster && \
apt-get -y install gettext-base && \
apt-get clean -y

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/entrypoint.sh /usr/bin/
COPY tools/init.sql /tmp

ENTRYPOINT ["entrypoint.sh"]
CMD ["mysqld"]
