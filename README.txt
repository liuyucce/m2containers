Docker development environment for Magento 2

To use this environment on your local env, make sure you are using Mac OS 10.14.2 or above/Linux, at least 8G memory and Core i5 processor.

The environment config file is /.env, most variables including website domains, project path, container ports mapping and PHP version etc. can be changed in this file.

This environment supports PHP 7.2/7.3 at the moment.

It will mount your user local ~/.ssh keys to the workspace container. Be careful to not share your built containers with others.

This environment does not use database in container for the performance optimization of Mac OS.

This environment disables memcache and Redis services by default. Services can be enabled by editing docker-compoer.yml file.

Varnish is configured to only serve https requests for the purpose of mimicking live traffic, and gives developer direct access to nginx via http at the same time.

Magento 2 multi-websites can be enabled in /nginx/conf_m2/magento2.conf.

Website domains should also be configured in /nginx/sites/app.conf when using nginx server.

Reverse proxy can have domains configured in /reverse-proxy/sites/app.conf

SSL have DNS configured in ssl/openssl.cnf 

Import ssl/ca.pem as root certificate for https access.

Xhgui profiling can be enabled by removing comment mark at  nginx/conf_m2/magento2.conf:169

Xhgui sampling rate can be changed in xhgui/config/config.php:63

Cron job path is configured in /workspace/crontab/laradock.

