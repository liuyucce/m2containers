Docker development environment for Magento 2

To use this environment on your local env, make sure you are using Mac OS 10.14.2 or above/Linux, at least 8G memory and Core i5 processor.

The environment config file is /.env, most variables including website domains, project path, container ports mapping and PHP version etc. can be changed in this file.

This environment supports PHP 7.1/7.2/7.3 at the moment.

To build project, run" for Linux "docker-compose -f docker-compose.yml -f docker-compose-$(uname -s).yml build".

To start project in Linux, run "docker-compose -f docker-compose.yml -f docker-compose-$(uname -s).yml up -d".

To start project in Mac, run sh sync up.

It will mount your user local ~/.ssh keys to the workspace container. Be careful to not share your built containers with others.

This environment does not use database in container for the performance optimization of Mac OS.

Varnish is configured to only serve https requests for the purpose of mimicking live traffic, and gives developer direct access to nginx via http at the same time.

SSL have DNS configured in ssl/openssl.cnf 

Import ssl/ca.pem as root certificate for https access.

xDebug can be enabled by uncommenting in /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini for workspace and /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini for php-fpm.

Xhgui profiling can be enabled by removing comment mark at nginx/conf_m2/magento2.conf:169 and uncomment in /etc/php/${PHP_VERSION}/cli/conf.d/tideways_xhprof.ini for workspace as well as /usr/local/etc/php/conf.d/tideways_xhprof.ini for php-fpm.

Xhgui sampling rate can be changed in xhgui/config/config.php:63

To use postfix, change the POSTFIX_SSMTP_DOMAIN to "127.0.0.1" for Linux and "postfix" for Mac.

Website domains should also be configured in /nginx/sites/app.conf when using nginx server.

Magento 2 multi-websites can be enabled in /nginx/conf_m2/magento2.conf.

Cron job path is configured in /workspace/crontab/laradock.
