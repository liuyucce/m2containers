FROM yushin/postfix:latest

COPY run.sh /
RUN chmod +x /run.sh

EXPOSE 25
CMD ["/run.sh"]
