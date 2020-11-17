#Dockerfile for a Postfix email relay service
FROM yushin/postfix:latest
MAINTAINER Yuchen Liu

COPY run.sh /
RUN chmod +x /run.sh

EXPOSE 25
CMD ["/run.sh"]
