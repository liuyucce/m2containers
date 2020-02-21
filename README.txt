Docker development environment for Magento 2

To use this environment on your local env, make sure you are using Mac OS 10.14.2 or above/Linux, at least 8G memory and Core i5 processor.

The environment config file is /.env, most variables including website domains, project path, container ports mapping and PHP version etc. can be changed in this file.

This environment supports PHP 7.1/7.2/7.3 at the moment.

To build project, run" for Linux "docker-compose -f docker-compose.yml -f docker-compose-$(uname -s).yml build".

To start project in Linux, run "docker-compose -f docker-compose.yml -f docker-compose-$(uname -s).yml up -d".

To start project in Mac, run sh sync up.

It will mount your user local ~/.ssh keys to the workspace container. Be careful to not share your built containers with others.

This environment does not use database in container for the performance optimization of Mac OS.

Varnish is configured to only serve https requests for the purpose of mimicking live traffic, and gives developer direct access to nginx via http at the same time. When use on MacOS, remember to add workspace and php-fpm to "acl purge" domains. To install geoip2 module, you have to put your maxmind AccountID and LicenseKey in varnish/etc/GeoIP.conf before building the proxy image.

Import ssl/certs/ca.pem as root certificate for https access.

xDebug can be enabled by uncommenting in ext-xdebug.ini in workspace and php-fpm. Set "remote_host" in workspace/xdebug.ini and php-fpm/xdebug.ini to "127.0.0.1" for Linux and "host.docker.internal" for mac. Note that after containers have been started up, you canot use vim but editors that won't create a new file after saving like nano to edit the config files to enable or disable xdebug.

Xhgui profiling can be enabled by removing comment mark at nginx/conf_m2/magento2.conf:169 and uncomment workspace/tideways_xhprof.ini or php-fpm/tideways_xhprof.ini to enable tideways module. Note that after containers have been started up, you canot use v
im but editors that won't create a new file after saving like nano to edit the config files to enable or disable tideways.
When using this project on Mac, remember to change the host domains in php-fpm/xhgui.config.php, xhgui/config/config.php and workspace/xhgui.config.php to "host.docker.internal".

Xhgui sampling rate can be changed in xhgui/config/config.php:63

To use postfix, change the POSTFIX_SSMTP_DOMAIN to "127.0.0.1" for Linux and "postfix" for Mac.

Website domains should also be configured in /nginx/sites/app.conf when using nginx server.

Magento 2 multi-websites can be enabled in /nginx/conf_m2/magento2.conf.

Cron job path is configured in /workspace/crontab/laradock.

On Linux, if any volume write permission issue occurs, try changing the owner of data directory ${DATA_PATH_HOST}  to current user like:
sudo chown -R $(id -u):$(id -g) ~/.laradock/data

Elasticsearch is not performing well on Mac. Disable elasticsearch and kibana if they are using too much system resources.
