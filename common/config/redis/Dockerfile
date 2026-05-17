FROM valkey/valkey:9.0.4-alpine3.23

## For security settings uncomment, make the dir, copy conf, and also start with the conf, to use it
#RUN mkdir -p /usr/local/etc/valkey
#COPY redis.conf /usr/local/etc/valkey/valkey.conf

VOLUME /data

EXPOSE 6379

#CMD ["valkey-server", "/usr/local/etc/valkey/valkey.conf"]
CMD ["valkey-server"]
