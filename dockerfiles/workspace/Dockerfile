#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#
# To edit the 'workspace' base Image, visit its repository on Github
#    https://github.com/Laradock/workspace
#
# To change its version, see the available Tags on the Docker Hub:
#    https://hub.docker.com/r/laradock/workspace/tags/
#
# Note: Base Image name format {image-tag}-{php-version}
#

ARG PHP_VERSION
ARG BASE_IMAGE_TAG_PREFIX=latest
FROM laradock/workspace:${BASE_IMAGE_TAG_PREFIX}-${PHP_VERSION}

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

# Start as root
USER root

# always run apt update when start and after add new source list, then clean up at end.
RUN set -xe; \
    apt-get update -yqq && \
    pecl channel-update pecl.php.net && \
    apt-get install -yqq \
      apt-utils iputils-ping telnet\
      #
      #--------------------------------------------------------------------------
      # Mandatory Software's Installation
      #--------------------------------------------------------------------------
      #
      # Mandatory Software's such as ("php-cli", "git", "vim", ....) are
      # installed on the base image 'laradock/workspace' image. If you want
      # to add more Software's or remove existing one, you need to edit the
      # base image (https://github.com/Laradock/workspace).
      #
      # next lines are here because there is no auto build on dockerhub see https://github.com/laradock/laradock/pull/1903#issuecomment-463142846
      libzip-dev zip unzip \
      # Install the zip extension
      php${PHP_VERSION}-zip \
      # nasm
      nasm && \
      php -m | grep -q 'zip'

#
#--------------------------------------------------------------------------
# Optional Software's Installation
#--------------------------------------------------------------------------
#
# Optional Software's will only be installed if you set them to `true`
# in the `docker-compose.yml` before the build.
# Example:
#   - INSTALL_NODE=false
#   - ...
#

###########################################################################
# User Aliases
###########################################################################

USER root

COPY ./aliases.sh /root/aliases.sh

RUN sed -i 's/\r//' /root/aliases.sh && \
    echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source ~/aliases.sh" >> ~/.bashrc && \
	  echo "" >> ~/.bashrc

###########################################################################
# BZ2:
###########################################################################

ARG INSTALL_BZ2=false
RUN if [ ${INSTALL_BZ2} = true ]; then \
  apt-get -y install php${PHP_VERSION}-bz2 \
;fi

###########################################################################
# GMP (GNU Multiple Precision):
###########################################################################

USER root

ARG INSTALL_GMP=false
ARG PHP_VERSION=${PHP_VERSION}

RUN if [ ${INSTALL_GMP} = true ]; then \
  # Install the PHP GMP extension
  apt-get -y install php${PHP_VERSION}-gmp \
;fi


###########################################################################
# SSH2:
###########################################################################

USER root

ARG INSTALL_SSH2=false

RUN if [ ${INSTALL_SSH2} = true ]; then \
  # Install the PHP SSH2 extension
  apt-get -y install libssh2-1-dev php${PHP_VERSION}-ssh2 \
;fi

###########################################################################
# SOAP:
###########################################################################

USER root

ARG INSTALL_SOAP=true

RUN if [ ${INSTALL_SOAP} = true ]; then \
  # Install the PHP SOAP extension
  apt-get -y install libxml2-dev php${PHP_VERSION}-soap \
;fi

###########################################################################
# LDAP:
###########################################################################

ARG INSTALL_LDAP=false

RUN if [ ${INSTALL_LDAP} = true ]; then \
    apt-get install -y libldap2-dev && \
    apt-get install -y php${PHP_VERSION}-ldap \
;fi

###########################################################################
# SMB:
###########################################################################

ARG INSTALL_SMB=false

RUN if [ ${INSTALL_SMB} = true ]; then \
    apt-get install -y smbclient php${PHP_VERSION}-smbclient coreutils \
;fi

###########################################################################
# IMAP:
###########################################################################

ARG INSTALL_IMAP=false

RUN if [ ${INSTALL_IMAP} = true ]; then \
    apt-get install -y php${PHP_VERSION}-imap \
;fi

###########################################################################
# xDebug:
###########################################################################

ARG INSTALL_XDEBUG=true

RUN if [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ]; then \
    # Install the xdebug extension
    pecl install xdebug-2.9.7; \
  else \
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ]; then \
      pecl install xdebug-3.3.2; \
    fi \
;fi

###########################################################################
# pcov:
###########################################################################

USER root

ARG INSTALL_PCOV=false

RUN if [ ${INSTALL_PCOV} = true ]; then \
    pecl install pcov && \
    echo "extension=pcov.so" >> /etc/php/${PHP_VERSION}/cli/php.ini && \
    echo "pcov.enabled" >> /etc/php/${PHP_VERSION}/cli/php.ini \
;fi


###########################################################################
# Phpdbg:
###########################################################################

USER root

ARG INSTALL_PHPDBG=false

RUN if [ ${INSTALL_PHPDBG} = true ]; then \
    # Load the xdebug extension only with phpunit commands
    apt-get install -y --force-yes php${PHP_VERSION}-phpdbg \
;fi

###########################################################################
# ssh:
###########################################################################

ARG INSTALL_SSH=true

COPY insecure_id_rsa /tmp/id_rsa
COPY insecure_id_rsa.pub /tmp/id_rsa.pub

RUN if [ ${INSTALL_SSH} = true ]; then \
    rm -f /etc/service/sshd/down && \
    cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys \
        && cat /tmp/id_rsa.pub >> /root/.ssh/id_rsa.pub \
        && cat /tmp/id_rsa >> /root/.ssh/id_rsa \
        && rm -f /tmp/id_rsa* \
        && chmod 644 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub \
    && chmod 400 /root/.ssh/id_rsa \
;fi

###########################################################################
# MongoDB:
###########################################################################

ARG INSTALL_MONGO=true

RUN if [ ${INSTALL_MONGO} = true ]; then \
    # Install the mongodb extension
    pecl install mongodb-1.15.0 && \
    echo "extension=mongodb.so" >> /etc/php/${PHP_VERSION}/mods-available/mongodb.ini && \
    ln -s /etc/php/${PHP_VERSION}/mods-available/mongodb.ini /etc/php/${PHP_VERSION}/cli/conf.d/30-mongodb.ini \
;fi

###########################################################################
# AMQP:
###########################################################################

ARG INSTALL_AMQP=false

RUN if [ ${INSTALL_AMQP} = true ]; then \
    apt-get install librabbitmq-dev -y && \
    pecl -q install amqp && \
    echo "extension=amqp.so" >> /etc/php/${PHP_VERSION}/mods-available/amqp.ini && \
    ln -s /etc/php/${PHP_VERSION}/mods-available/amqp.ini /etc/php/${PHP_VERSION}/cli/conf.d/30-amqp.ini \
;fi

###########################################################################
# CASSANDRA:
###########################################################################

ARG INSTALL_CASSANDRA=false

RUN if [ ${INSTALL_CASSANDRA} = true ]; then \
    apt-get install libgmp-dev -y && \
    curl https://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.28.0/libuv1-dev_1.28.0-1_amd64.deb -o libuv1-dev.deb && \
    curl https://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.28.0/libuv1_1.28.0-1_amd64.deb -o libuv1.deb && \
    curl https://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.12.0/cassandra-cpp-driver-dev_2.12.0-1_amd64.deb -o cassandra-cpp-driver-dev.deb && \
    curl https://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.12.0/cassandra-cpp-driver_2.12.0-1_amd64.deb -o cassandra-cpp-driver.deb && \
    dpkg -i libuv1.deb && \
    dpkg -i libuv1-dev.deb && \
    dpkg -i cassandra-cpp-driver.deb && \
    dpkg -i cassandra-cpp-driver-dev.deb && \
    rm libuv1.deb libuv1-dev.deb cassandra-cpp-driver-dev.deb cassandra-cpp-driver.deb && \
    cd /usr/src && \
    git clone https://github.com/datastax/php-driver.git && \
    cd /usr/src/php-driver/ext && \
    phpize && \
    mkdir /usr/src/php-driver/build && \
    cd /usr/src/php-driver/build && \
    ../ext/configure > /dev/null && \
    make clean >/dev/null && \
    make >/dev/null 2>&1 && \
    make install && \
    echo "extension=cassandra.so" >> /etc/php/${PHP_VERSION}/mods-available/cassandra.ini && \
    ln -s /etc/php/${PHP_VERSION}/mods-available/cassandra.ini /etc/php/${PHP_VERSION}/cli/conf.d/30-cassandra.ini \
;fi

###########################################################################
# Gearman:
###########################################################################

ARG INSTALL_GEARMAN=false

RUN if [ ${INSTALL_GEARMAN} = true ]; then \
    add-apt-repository -y ppa:ondrej/pkg-gearman && \
    apt-get update && \
    apt-get install php${PHP_VERSION}-gearman -y  \
;fi

###########################################################################
# PHP REDIS EXTENSION
###########################################################################

ARG INSTALL_PHPREDIS=true

RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
    apt-get update -yqq && \
    apt-get install -yqq php${PHP_VERSION}-redis \
;fi

###########################################################################
# Swoole EXTENSION
###########################################################################

ARG INSTALL_SWOOLE=false

RUN if [ ${INSTALL_SWOOLE} = true ]; then \
    # Install Php Swoole Extension
    pecl install swoole; \
    echo "extension=swoole.so" >> /etc/php/${PHP_VERSION}/mods-available/swoole.ini && \
    ln -s /etc/php/${PHP_VERSION}/mods-available/swoole.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-swoole.ini \
    && php -m | grep -q 'swoole' \
;fi

###########################################################################
# Taint EXTENSION
###########################################################################

ARG INSTALL_TAINT=false

RUN if [ "${INSTALL_TAINT}" = true ]; then \
    # Install Php TAINT Extension
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ]; then \
      pecl install taint && \
      echo "extension=taint.so" >> /etc/php/${PHP_VERSION}/mods-available/taint.ini && \
      ln -s /etc/php/${PHP_VERSION}/mods-available/taint.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-taint.ini && \
      php -m | grep -q 'taint'; \
    fi \
;fi

###########################################################################
# Libpng16 EXTENSION
###########################################################################

ARG INSTALL_LIBPNG=false

RUN if [ ${INSTALL_LIBPNG} = true ]; then \
    apt-get update && \
    apt-get install libpng16-16 \
;fi

###########################################################################
# Inotify EXTENSION:
###########################################################################

ARG INSTALL_INOTIFY=false

RUN if [ ${INSTALL_INOTIFY} = true ]; then \
    pecl -q install inotify && \
    echo "extension=inotify.so" >> /etc/php/${PHP_VERSION}/mods-available/inotify.ini && \
    ln -s /etc/php/${PHP_VERSION}/mods-available/inotify.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-inotify.ini \
;fi

###########################################################################
# AST EXTENSION
###########################################################################

ARG INSTALL_AST=true
ARG AST_VERSION=1.1.0
ENV AST_VERSION ${AST_VERSION}

RUN if [ ${INSTALL_AST} = true ]; then \
    # Install AST extension
    printf "\n" | pecl -q install ast-${AST_VERSION} && \
    echo "extension=ast.so" >> /etc/php/${PHP_VERSION}/mods-available/ast.ini && \
    phpenmod -v ${PHP_VERSION} -s cli ast \
;fi

###########################################################################
# fswatch
###########################################################################

ARG INSTALL_FSWATCH=false

RUN if [ ${INSTALL_FSWATCH} = true ]; then \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 47FE03C1 \
    && add-apt-repository -y ppa:hadret/fswatch \
    || apt-get update -yqq \
    && apt-get -y install fswatch \
;fi

###########################################################################

# GraphViz extension
###########################################################################

ARG INSTALL_GRAPHVIZ=false

RUN if [ ${INSTALL_GRAPHVIZ} = true ]; then \
    apt-get update && \
    apt-get install -y graphviz \
;fi

# IonCube Loader
###########################################################################

ARG INSTALL_IONCUBE=false

RUN if [ ${INSTALL_IONCUBE} = true ]; then \
    # Install the php ioncube loader
    curl -L -o /tmp/ioncube_loaders_lin_x86-64.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar zxpf /tmp/ioncube_loaders_lin_x86-64.tar.gz -C /tmp \
    && mv /tmp/ioncube/ioncube_loader_lin_${PHP_VERSION}.so $(php -r "echo ini_get('extension_dir');")/ioncube_loader.so \
    && echo "zend_extension=ioncube_loader.so" >> /etc/php/${PHP_VERSION}/mods-available/0ioncube.ini \
    && rm -rf /tmp/ioncube* \
;fi

###########################################################################
# PHP Aerospike:
###########################################################################

USER root

ARG INSTALL_AEROSPIKE=false

RUN set -xe; \
  if [ ${INSTALL_AEROSPIKE} = true ]; then \
    # Fix dependencies for PHPUnit within aerospike extension
    apt-get -y install sudo wget \
    # Install the php aerospike extension
    && curl -L -o /tmp/aerospike-client-php.tar.gz https://github.com/aerospike/aerospike-client-php/archive/master.tar.gz \
    && mkdir -p /tmp/aerospike-client-php \
    && tar -C /tmp/aerospike-client-php -zxvf /tmp/aerospike-client-php.tar.gz --strip 1 \
    && \
        ( \
            cd /tmp/aerospike-client-php/src \
            && phpize \
            && ./build.sh \
            && make install \
        ) \
    && rm /tmp/aerospike-client-php.tar.gz \
    && echo 'extension=aerospike.so' >> /etc/php/${PHP_VERSION}/cli/conf.d/aerospike.ini \
    && echo 'aerospike.udf.lua_system_path=/usr/local/aerospike/lua' >> /etc/php/${PHP_VERSION}/cli/conf.d/aerospike.ini \
    && echo 'aerospike.udf.lua_user_path=/usr/local/aerospike/usr-lua' >> /etc/php/${PHP_VERSION}/cli/conf.d/aerospike.ini \
  ;fi

###########################################################################
# PHP OCI8:
###########################################################################

USER root
ARG INSTALL_OCI8=false

ENV LD_LIBRARY_PATH="/opt/oracle/instantclient_12_1"
ENV OCI_HOME="/opt/oracle/instantclient_12_1"
ENV OCI_LIB_DIR="/opt/oracle/instantclient_12_1"
ENV OCI_INCLUDE_DIR="/opt/oracle/instantclient_12_1/sdk/include"
ENV OCI_VERSION=12

RUN if [ ${INSTALL_OCI8} = true ]; then \
  # Install wget
  apt-get update && apt-get install --no-install-recommends -y wget \
  # Install Oracle Instantclient
  && mkdir /opt/oracle \
      && cd /opt/oracle \
      && wget https://github.com/diogomascarenha/oracle-instantclient/raw/master/instantclient-basic-linux.x64-12.1.0.2.0.zip \
      && wget https://github.com/diogomascarenha/oracle-instantclient/raw/master/instantclient-sdk-linux.x64-12.1.0.2.0.zip \
      && unzip /opt/oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /opt/oracle \
      && unzip /opt/oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /opt/oracle \
      && ln -s /opt/oracle/instantclient_12_1/libclntsh.so.12.1 /opt/oracle/instantclient_12_1/libclntsh.so \
      && ln -s /opt/oracle/instantclient_12_1/libclntshcore.so.12.1 /opt/oracle/instantclient_12_1/libclntshcore.so \
      && ln -s /opt/oracle/instantclient_12_1/libocci.so.12.1 /opt/oracle/instantclient_12_1/libocci.so \
      && rm -rf /opt/oracle/*.zip \
  # Install PHP extensions deps
  && apt-get update \
      && apt-get install --no-install-recommends -y \
          libaio-dev \
  # Install PHP extensions
  && echo 'instantclient,/opt/oracle/instantclient_12_1/' | pecl install oci8 \
  && echo "extension=oci8.so" >> /etc/php/${PHP_VERSION}/cli/php.ini \
  && php -m | grep -q 'oci8' \
;fi

###########################################################################
# PHP V8JS:
###########################################################################

USER root

ARG INSTALL_V8JS=false

RUN set -xe; \
  if [ ${INSTALL_V8JS} = true ]; then \
    add-apt-repository -y ppa:pinepain/libv8-archived \
    && apt-get update -yqq \
    && apt-get install -y libv8-5.4 \
    && pecl install v8js \
    && echo "extension=v8js.so" >> /etc/php/${PHP_VERSION}/cli/php.ini \
    && php -m | grep -q 'v8js' \
  ;fi

###########################################################################
# Deployer:
###########################################################################

USER root

ARG INSTALL_DEPLOYER=false

RUN if [ ${INSTALL_DEPLOYER} = true ]; then \
    # Install the Deployer
    # Using Phar as currently there is no support for laravel 4 from composer version
    # Waiting to be resolved on https://github.com/deployphp/deployer/issues/1552
    curl -LO https://deployer.org/deployer.phar && \
    mv deployer.phar /usr/local/bin/dep && \
    chmod +x /usr/local/bin/dep \
;fi

###########################################################################
# Linuxbrew:
###########################################################################

USER root

ARG INSTALL_LINUXBREW=false

RUN if [ ${INSTALL_LINUXBREW} = true ]; then \
    # Preparation
    apt-get upgrade -y && \
    apt-get install -y build-essential make cmake scons curl git \
      ruby autoconf automake autoconf-archive \
      gettext libtool flex bison \
      libbz2-dev libcurl4-openssl-dev \
      libexpat-dev libncurses-dev && \
    # Install the Linuxbrew
    git clone --depth=1 https://github.com/Homebrew/linuxbrew.git ~/.linuxbrew && \
    echo "" >> ~/.bashrc && \
    echo 'export PKG_CONFIG_PATH"=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:/usr/lib64/pkgconfig:/usr/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig:$PKG_CONFIG_PATH"' >> ~/.bashrc && \
    # Setup linuxbrew
    echo 'export LINUXBREWHOME="$HOME/.linuxbrew"' >> ~/.bashrc && \
    echo 'export PATH="$LINUXBREWHOME/bin:$PATH"' >> ~/.bashrc && \
    echo 'export MANPATH="$LINUXBREWHOME/man:$MANPATH"' >> ~/.bashrc && \
    echo 'export PKG_CONFIG_PATH="$LINUXBREWHOME/lib64/pkgconfig:$LINUXBREWHOME/lib/pkgconfig:$PKG_CONFIG_PATH"' >> ~/.bashrc && \
    echo 'export LD_LIBRARY_PATH="$LINUXBREWHOME/lib64:$LINUXBREWHOME/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc \
;fi

###########################################################################
# SQL SERVER:
###########################################################################

ARG INSTALL_MSSQL=false

RUN set -eux; \
  if [ ${INSTALL_MSSQL} = true ]; then \
      ###########################################################################
      #  The following steps were taken from
      #  https://github.com/Microsoft/msphpsql/wiki/Install-and-configuration
      ###########################################################################
      curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
      curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
      apt-get update -yqq && \
      ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools unixodbc unixodbc-dev libgss3 odbcinst locales && \
      ln -sfn /opt/mssql-tools/bin/sqlcmd /usr/bin/sqlcmd && \
      ln -sfn /opt/mssql-tools/bin/bcp /usr/bin/bcp && \
      echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
      locale-gen && \
      if [ $(php -r "echo PHP_VERSION_ID - PHP_RELEASE_VERSION;") = "70000" ]; then \
        pecl install sqlsrv-5.3.0 pdo_sqlsrv-5.3.0 \
      ;elif [ $(php -r "echo PHP_VERSION_ID - PHP_RELEASE_VERSION;") = "70100" ]; then \
        pecl install sqlsrv-5.6.1 pdo_sqlsrv-5.6.1 \
      ;else \
        pecl install sqlsrv pdo_sqlsrv \
      ;fi && \
      echo "extension=sqlsrv.so"     > /etc/php/${PHP_VERSION}/cli/conf.d/20-sqlsrv.ini && \
      echo "extension=pdo_sqlsrv.so" > /etc/php/${PHP_VERSION}/cli/conf.d/20-pdo_sqlsrv.ini \
      && php -m | grep -q 'sqlsrv' \
      && php -m | grep -q 'pdo_sqlsrv' \
  ;fi

###########################################################################
# Image optimizers:
###########################################################################

USER root

ARG INSTALL_IMAGE_OPTIMIZERS=true

RUN if [ ${INSTALL_IMAGE_OPTIMIZERS} = true ]; then \
    apt-get install -y jpegoptim optipng pngquant gifsicle && \
    if [ ${INSTALL_NODE} = true ]; then \
        exec bash && . ~/.bashrc && npm install -g svgo \
    ;fi\
;fi

###########################################################################
# PYTHON3:
###########################################################################

ARG INSTALL_PYTHON3=true

RUN if [ ${INSTALL_PYTHON3} = true ]; then \
  apt-get -y install python3 python3-pip python3-dev build-essential  \
  && python3 -m pip install --upgrade --force-reinstall pip  \
  && python3 -m pip install --upgrade virtualenv \
;fi

###########################################################################
# SUPERVISOR:
###########################################################################
ARG INSTALL_SUPERVISOR=false

RUN if [ ${INSTALL_SUPERVISOR} = true ]; then \
    if [ ${INSTALL_PYTHON} = true ]; then \
    python -m pip install --upgrade supervisor && \
    echo_supervisord_conf > /etc/supervisord.conf && \
    sed -i 's/\;\[include\]/\[include\]/g' /etc/supervisord.conf && \
    sed -i 's/\;files\s.*/files = supervisord.d\/*.conf/g' /etc/supervisord.conf \
  ;fi \
;fi

USER laradock

###########################################################################
# ImageMagick:
###########################################################################

USER root

ARG INSTALL_IMAGEMAGICK=true

RUN if [ ${INSTALL_IMAGEMAGICK} = true ]; then \
    apt-get install -y imagemagick php${PHP_VERSION}-imagick \
;fi

###########################################################################
# Terraform:
###########################################################################

USER root

ARG INSTALL_TERRAFORM=false

RUN if [ ${INSTALL_TERRAFORM} = true ]; then \
    apt-get -y install sudo wget unzip \
    && wget https://releases.hashicorp.com/terraform/0.10.6/terraform_0.10.6_linux_amd64.zip \
    && unzip terraform_0.10.6_linux_amd64.zip \
    && mv terraform /usr/local/bin \
    && rm terraform_0.10.6_linux_amd64.zip \
;fi
###########################################################################
# pgsql client
###########################################################################

USER root

ARG INSTALL_PG_CLIENT=false

RUN if [ ${INSTALL_PG_CLIENT} = true ]; then \
    # Install the pgsql client
    apt-get install wget \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get -y install postgresql-client-12 \
;fi

###########################################################################
# MySQL Client:
###########################################################################

USER root

ARG INSTALL_MYSQL_CLIENT=true

RUN if [ ${INSTALL_MYSQL_CLIENT} = true ]; then \
    apt-get update -yqq && \
    apt-get -y install mysql-client \
;fi

###########################################################################
# sshpass:
###########################################################################

USER root

ARG INSTALL_SSHPASS=false

RUN if [ ${INSTALL_SSHPASS} = true ]; then \
    apt-get update -yqq && \
    apt-get -y install sshpass \
;fi

###########################################################################
# YAML: extension for PHP-CLI
###########################################################################

USER root

ARG INSTALL_YAML=false

RUN if [ ${INSTALL_YAML} = true ]; then \
    apt-get install libyaml-dev -y ; \
    pecl install yaml \
    echo "extension=yaml.so" >> /etc/php/${PHP_VERSION}/mods-available/yaml.ini && \
    ln -s /etc/php/${PHP_VERSION}/mods-available/yaml.ini /etc/php/${PHP_VERSION}/cli/conf.d/35-yaml.ini \
;fi

###########################################################################
# RDKAFKA:
###########################################################################

ARG INSTALL_RDKAFKA=false

RUN if [ ${INSTALL_RDKAFKA} = true ]; then \
    apt-get install -y librdkafka-dev && \
    pecl install rdkafka && \
    echo "extension=rdkafka.so" >> /etc/php/${PHP_VERSION}/mods-available/rdkafka.ini && \
    ln -s /etc/php/${PHP_VERSION}/mods-available/rdkafka.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-rdkafka.ini \
    && php -m | grep -q 'rdkafka' \
;fi

###########################################################################
# FFMpeg:
###########################################################################

USER root

ARG INSTALL_FFMPEG=false

RUN if [ ${INSTALL_FFMPEG} = true ]; then \
  apt-get -y install ffmpeg \
;fi

#####################################
# wkhtmltopdf:
#####################################

USER root

ARG INSTALL_WKHTMLTOPDF=false

RUN if [ ${INSTALL_WKHTMLTOPDF} = true ]; then \
   apt-get install -y \
   libxrender1 \
   libfontconfig1 \
   libx11-dev \
   libjpeg62 \
   libxtst6 \
   fontconfig \ 
   libjpeg-turbo8-dev \
   xfonts-base \
   xfonts-75dpi \
   wget \
   && wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb \
   && dpkg -i wkhtmltox_0.12.6-1.bionic_amd64.deb \
   && apt -f install \
;fi

###########################################################################
# Mailparse extension:
###########################################################################

ARG INSTALL_MAILPARSE=false

RUN if [ ${INSTALL_MAILPARSE} = true ]; then \
    apt-get install -yqq php${PHP_VERSION}-mailparse \
;fi

###########################################################################
# GNU Parallel:
###########################################################################

USER root

ARG INSTALL_GNU_PARALLEL=false

RUN if [ ${INSTALL_GNU_PARALLEL} = true ]; then \
  apt-get -y install parallel \
;fi

###########################################################################
# Bash Git Prompt
###########################################################################

ARG INSTALL_GIT_PROMPT=false

COPY git-prompt.sh /tmp/git-prompt

RUN if [ ${INSTALL_GIT_PROMPT} = true ]; then \
    git clone https://github.com/magicmonty/bash-git-prompt.git /root/.bash-git-prompt --depth=1 && \
    cat /tmp/git-prompt >> /root/.bashrc && \
    rm /tmp/git-prompt \
;fi

###########################################################################
# XMLRPC:
###########################################################################

ARG INSTALL_XMLRPC=false

RUN if [ ${INSTALL_XMLRPC} = true ]; then \
    docker-php-ext-install xmlrpc \
;fi

###########################################################################
# Lnav:
###########################################################################

ARG INSTALL_LNAV=false

RUN if [ ${INSTALL_LNAV} = true ]; then \
    apt-get install -y lnav \
;fi

###########################################################################
# Protoc:
###########################################################################

ARG INSTALL_PROTOC=false
ARG PROTOC_VERSION

RUN if [ ${INSTALL_PROTOC} = true ]; then \
  if [ ${PROTOC_VERSION} = "latest" ]; then \
    REAL_PROTOC_VERSION=$(curl -s https://api.github.com/repos/protocolbuffers/protobuf/releases/latest | \
      sed -nr 's/.*"tag_name":\s?"v(.+?)".*/\1/p'); \
  else \
    REAL_PROTOC_VERSION=${PROTOC_VERSION}; \
  fi && \
  PROTOC_ZIP=protoc-${REAL_PROTOC_VERSION}-linux-x86_64.zip; \
  curl -L -o /tmp/protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/v${REAL_PROTOC_VERSION}/${PROTOC_ZIP} && \
  unzip -q -o /tmp/protoc.zip -d /usr/local bin/protoc && \
  unzip -q -o /tmp/protoc.zip -d /usr/local 'include/*' && \
  rm -f /tmp/protoc.zip && \
  chmod +x /usr/local/bin/protoc && \
  chmod -R +r /usr/local/include/google \
;fi

###########################################################################
# Tideways:
###########################################################################

USER root

ARG INSTALL_XHPROF=true

WORKDIR /tmp

RUN if [ ${INSTALL_XHPROF} = true ]; then \
    pecl install xhprof-2.3.9 \
;fi

###########################################################################
# Sodium for temporary version issue:
###########################################################################

USER root

WORKDIR /tmp

RUN curl -O https://download.libsodium.org/libsodium/releases/libsodium-1.0.18-stable.tar.gz \
  && tar xfvz libsodium-1.0.18-stable.tar.gz \
  && cd libsodium-stable \
  && ./configure \
  && make && make install \
  && pecl install -f libsodium

###########################################################################
# MSMTP:
###########################################################################

USER root

ARG INSTALL_MSMTP=true

RUN if [ ${INSTALL_MSMTP} = true ]; then \
    apt install -y msmtp-mta \
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
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

# Set default work directory
WORKDIR /var/www
