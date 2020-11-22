#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#
# To edit the 'php-fpm' base Image, visit its repository on Github
#    https://github.com/Laradock/php-fpm
#
# To change its version, see the available Tags on the Docker Hub:
#    https://hub.docker.com/r/laradock/php-fpm/tags/
#
# Note: Base Image name format {image-tag}-{php-version}
#

ARG PHP_VERSION
FROM yushin/php-fpm:${PHP_VERSION}

ARG PHP_VERSION

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

# always run apt update when start and after add new source list, then clean up at end.
RUN apt-get update -yqq

###########################################################################
# MSMTP:
###########################################################################

USER root

ARG INSTALL_MSMTP=true
ARG EMAIL_SERVICE_URL=${EMAIL_SERVICE_URL}
ARG MSMTP_DOMAIN=${MSMTP_DOMAIN}

COPY ./etc/msmtprc /etc/msmtprc

RUN if [ ${INSTALL_MSMTP} = true ]; then \
    sed -ri -e "s/demo.local/${MSMTP_DOMAIN}/" -e "s/postfix/${EMAIL_SERVICE_URL}/" /etc/msmtprc \
;fi


###########################################################################
# Check PHP version:
###########################################################################

RUN set -xe; php -v | head -n 1 | grep -q "PHP ${PHP_VERSION}."

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

USER root

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure non-root user.
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

RUN groupmod -o -g ${PGID} www-data && \
    usermod -o -u ${PUID} -g www-data www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
