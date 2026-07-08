FROM varnish:8.0.2

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

COPY etc/varnish/default.vcl /etc/varnish/default.vcl
COPY etc/varnish/geoip.vcl /etc/varnish/geoip.vcl
COPY etc/varnish/start.sh /etc/varnish/start.sh

WORKDIR /var/tmp

ARG INSTALL_GEOIP2=false
ENV INSTALL_GEOIP2 ${INSTALL_GEOIP2}

# Build and install libvmod-geoip2 (heavy step; cached unless the ARG above changes).
RUN if [ "${INSTALL_GEOIP2}" = "true" ]; then \
    apt-get update && \
    VARNISH_VERSION=$(dpkg -s varnish | grep '^Version:' | awk '{print $2}') && \
    apt-get install -y --no-install-recommends \
        wget git m4 autoconf automake libtool make pkg-config \
        python3 python3-docutils procps "varnish-dev=${VARNISH_VERSION}" && \
    ARCH=$(dpkg --print-architecture) && \
    wget -q "https://github.com/maxmind/geoipupdate/releases/download/v7.1.1/geoipupdate_7.1.1_linux_${ARCH}.deb" && \
    dpkg -i "geoipupdate_7.1.1_linux_${ARCH}.deb" && \
    rm "geoipupdate_7.1.1_linux_${ARCH}.deb" && \
    wget -q https://github.com/maxmind/libmaxminddb/releases/download/1.13.3/libmaxminddb-1.13.3.tar.gz && \
    tar -zxf libmaxminddb-1.13.3.tar.gz && cd libmaxminddb-1.13.3 && \
    ./configure && make && make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf && ldconfig && \
    cd /var/tmp && git clone --depth=1 https://github.com/varnishcache-friends/libvmod-geoip2.git && \
    cd libvmod-geoip2 && export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig && \
    ./autogen.sh && ./configure && make && make install && \
    cd /var/tmp && rm -rf libmaxminddb-1.13.3 libmaxminddb-1.13.3.tar.gz libvmod-geoip2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* \
;fi

# Kept in a separate layer so that changing GeoIP.conf or credentials
# invalidates only the database download, not the VMOD build above.
COPY etc/GeoIP.conf /etc/GeoIP.conf

RUN if [ "${INSTALL_GEOIP2}" = "true" ]; then \
    mkdir -p /usr/share/GeoIP && \
    geoipupdate \
;fi

RUN chmod +x /etc/varnish/start.sh

CMD ["/etc/varnish/start.sh"]

EXPOSE 6081 6082
