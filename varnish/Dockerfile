FROM debian:latest

LABEL maintainer="ZeroC0D3 Team<zeroc0d3.team@gmail.com>"

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN apt-get update && apt-get install -y apt-utils && apt-get upgrade -y
RUN apt-get install -y debian-archive-keyring curl gnupg apt-transport-https
RUN curl -L https://packagecloud.io/varnishcache/varnish60lts/gpgkey | apt-key add -
#RUN . /etc/os-release && echo "deb https://packagecloud.io/varnishcache/varnish60lts/debian/ $VERSION_CODENAME main\ndeb-src https://packagecloud.io/varnishcache/varnish60lts/debian/ $VERSION_CODENAME main" > /etc/apt/sources.list.d/varnishcache_varnish60lts.list
RUN . /etc/os-release && echo "deb https://packagecloud.io/varnishcache/varnish60lts/debian/ stretch  main\ndeb-src https://packagecloud.io/varnishcache/varnish60lts/debian/ stretch main" > /etc/apt/sources.list.d/varnishcache_varnish60lts.list
RUN apt-get update
RUN mkdir /home/site && mkdir /home/site/cache
RUN apt-get install -y varnish
RUN rm -rf /var/lib/apt/lists/*

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
    apt-get update && apt-get install -y wget m4 automake libtool make python python-docutils procps varnish-dev && \
    wget https://github.com/maxmind/geoipupdate/releases/download/v4.1.5/geoipupdate_4.1.5_linux_amd64.deb && \
    dpkg -i geoipupdate_4.1.5_linux_amd64.deb && \
    wget https://github.com/maxmind/libmaxminddb/releases/download/1.4.2/libmaxminddb-1.4.2.tar.gz && \
    tar -zxf libmaxminddb-1.4.2.tar.gz && cd libmaxminddb-1.4.2 && \
    ./configure && make && make install && ldconfig && \
    cd /var/tmp && wget https://github.com/fgsch/libvmod-geoip2/archive/v1.2.1.tar.gz && \
    tar -zxf v1.2.1.tar.gz && cd libvmod-geoip2-1.2.1 && \
    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig && \
    ./autogen.sh && ./configure && make && make install && \
    geoipupdate \
;fi

COPY etc/GeoIP.conf /etc/GeoIP.conf

RUN chmod +x /etc/varnish/start.sh

CMD ["/etc/varnish/start.sh"]

EXPOSE 6081 6082
