FROM debian:buster

ARG VSFTPD_V
ARG ADMIN_LOG
ARG ADMIN_PASS

MAINTAINER etakouer <etakouer@student.42nice.fr>

RUN apt-get -y update && \
apt-get -y install vsftpd=$VSFTPD_V-12

RUN echo $ADMIN_LOG > /etc/vsftpd.userlist && \
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' "$ADMIN_PASS") $ADMIN_LOG && \
mkdir -p /var/run/vsftpd/empty && \
cp /etc/vsftpd.conf /etc/_vsftp.conf

EXPOSE 21 20

CMD ["vsftpd"]
