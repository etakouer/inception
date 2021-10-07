FROM debian:buster

MAINTAINER etakouer <etakouer@student.42nice.fr>

ARG REDIS_V

# Download from source
RUN apt-get -y update && \
apt-get -y install build-essential wget pkg-config && \
wget https://download.redis.io/releases/redis-$REDIS_V.tar.gz && \
tar xzf redis-$REDIS_V.tar.gz && \
rm redis-$REDIS_V.tar.gz && \ 
mv redis-$REDIS_V redis

# make
RUN cd redis && \
make && \
cp src/redis-server /usr/bin/ && \
cp src/redis-cli /usr/bin/

WORKDIR /data

CMD ["redis-server", "/etc/redis/redis.conf"]
