#Dockerfile for a Postfix email relay service
FROM centos:centos7
MAINTAINER Yuchen Liu

COPY etc/yum.repos.d/gf.repo /etc/yum.repos.d/
COPY etc/pki/rpm-gpg/RPM-GPG-KEY-gf.el7 etc/pki/rpm-gpg/

RUN yum clean all && \
    yum makecache fast && \
    yum install -y epel-release && yum update -y && \
    yum install -y cyrus-sasl cyrus-sasl-plain cyrus-sasl-md5 mailx \
    perl supervisor postfix3 rsyslog \
    && rm -rf /var/cache/yum/* \
    && yum clean all
RUN sed -i -e "s/^nodaemon=false/nodaemon=true/" /etc/supervisord.conf
RUN sed -i -e 's/inet_interfaces = localhost/inet_interfaces = all/g' /etc/postfix/main.cf

COPY etc/*.conf /etc/
COPY etc/rsyslog.d/* /etc/rsyslog.d
COPY etc/supervisord.d/*.ini /etc/supervisord.d/
RUN newaliases

EXPOSE 25
CMD ["supervisord"]
