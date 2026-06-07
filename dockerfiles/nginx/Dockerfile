# Stage 1: Compile nginx image_filter module with WebP support
# nginx 1.30.2 source already has WebP code guarded by NGX_HAVE_GD_WEBP.
# configure sets NGX_HAVE_GD_WEBP=1 when gdImageWebpPtr is found in libgd.
FROM nginx:1.30.2-alpine3.23 AS builder

RUN apk add --no-cache \
    build-base \
    curl \
    gd-dev \
    libwebp-dev \
    pcre-dev \
    pcre2-dev \
    zlib-dev

ARG NGINX_VERSION=1.30.2

RUN mkdir -p /usr/src \
    && curl -fsSL "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" \
    | tar xz -C /usr/src

RUN cd /usr/src/nginx-${NGINX_VERSION} \
    && ./configure \
        --with-compat \
        --with-http_image_filter_module=dynamic \
    && make modules

# Fail the build early if WebP symbols are absent from the compiled module
RUN nm /usr/src/nginx-${NGINX_VERSION}/objs/ngx_http_image_filter_module.so \
    | grep -qi webp \
    && echo "image_filter WebP support: OK" \
    || { echo "ERROR: image_filter module was not compiled with WebP support"; exit 1; }

RUN cp /usr/src/nginx-${NGINX_VERSION}/objs/ngx_http_image_filter_module.so /tmp/


# Stage 2: Final image
FROM nginx:1.30.2-alpine3.23

LABEL maintainer="Yuchen Liu"

COPY nginx.conf /etc/nginx/

RUN apk update \
    && apk upgrade \
    && apk --update add logrotate \
    && apk add --no-cache openssl \
    && apk add --no-cache bash \
    && apk add --no-cache libwebp \
    && apk add --no-cache nginx-module-image-filter

# Overwrite the pre-built module with the WebP-enabled version from the builder
COPY --from=builder /tmp/ngx_http_image_filter_module.so \
    /etc/nginx/modules/ngx_http_image_filter_module.so

# Verify libgd links against libwebp at runtime
RUN ldd $(find /usr/lib -name "libgd.so*" 2>/dev/null | head -1) 2>/dev/null \
    | grep -qi webp \
    && echo "libgd WebP support: OK" \
    || { echo "ERROR: libgd does not have WebP support"; exit 1; }

RUN apk add --no-cache curl

RUN set -x ; \
    delgroup www-data ; \
    addgroup -g 5353 -S www-data ; \
    adduser -u 5353 -D -S -G www-data www-data && exit 0 ; exit 1

RUN touch /var/log/messages

COPY logrotate/nginx /etc/logrotate.d/

CMD ["/bin/bash"]

EXPOSE 80 443
