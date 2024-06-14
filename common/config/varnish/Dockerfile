FROM varnish:7.5

USER root

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

# Setting Configurations
ENV VARNISH_CONFIG  /etc/varnish/default.vcl
ENV CACHE_SIZE      128m
ENV VARNISHD_PARAMS -p default_ttl=3600 -p default_grace=3600
ENV VARNISH_PORT    6081
ENV BACKEND_HOST    localhost
ENV BACKEND_PORT    80

COPY default.vcl /etc/varnish/default.vcl
COPY start.sh /etc/varnish/start.sh

WORKDIR /var/tmp

ARG INSTALL_GEOIP2=false
ENV INSTALL_GEOIP2 ${INSTALL_GEOIP2}

RUN if [ ${INSTALL_GEOIP2} = true ]; then \
    apt-get update && apt-get install -y wget git m4 automake libtool make python3 python3-docutils procps varnish-dev && \
    wget https://github.com/maxmind/geoipupdate/releases/download/v7.0.1/geoipupdate_7.0.1_linux_amd64.deb && \
    dpkg -i geoipupdate_7.0.1_linux_amd64.deb && \
    wget https://github.com/maxmind/libmaxminddb/releases/download/1.10.0/libmaxminddb-1.10.0.tar.gz && \
    tar -zxf libmaxminddb-1.10.0.tar.gz && cd libmaxminddb-1.10.0 && \
    ./configure && make && make install && ldconfig && \
    cd /var/tmp && git clone https://github.com/varnishcache-friends/libvmod-geoip2.git && \
    cd libvmod-geoip2 && export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig && \
    ./autogen.sh && ./configure && make && make install \
;fi

COPY etc/GeoIP.conf /etc/GeoIP.conf

RUN if [ ${INSTALL_GEOIP2} = true ]; then \
    geoipupdate \
;fi

RUN chmod +x /etc/varnish/start.sh

CMD ["/etc/varnish/start.sh"]

EXPOSE 6081 6082
