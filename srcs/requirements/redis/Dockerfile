FROM debian:buster

MAINTAINER etakouer <etakouer@student.42nice.fr>

ARG REDIS_V

# update repository
RUN apt-get -y update && \
apt-get -y install software-properties-common curl gnupg2 ; \
curl https://packages.redis.io/gpg | apt-key add - ; \
echo "deb https://packages.redis.io/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/redis.list ; \
apt-get -y update

# install
RUN apt-get -y install redis

EXPOSE 6379

WORKDIR /data

CMD ["redis-server", "/etc/redis/redis.conf"]
