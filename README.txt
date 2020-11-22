Docker development environment for Magento 2

To use this environment on your local env, make sure you are using Mac OS 10.14.2 or above/Windows with WSL2/Linux, at least 8G memory and Core i5 processor.

The environment config file is /local/<your_env>/.env, most variables including website domains, project path, container ports mapping and PHP version etc. can be changed in this file.

This environment supports PHP 7.3 at the moment.

To build project, run "docker-compose build" in corresponding environment to your OS.

To start project, run "docker-compose up -d" in corresponding environment to your OS.

To start project in Mac, run "sh sync up" in corresponding environment to your OS. Run "sh sync bash" to connect to workspace container. 

In workspace container, run "su laradock" to switcher to the project owner and "cd app" to enter the project root directory.

It will mount /local/<your_env>/volumes/ssh keys to the workspace container. Be careful to not share your built containers with others.

Varnish is configured to only serve https requests for the purpose of mimicking live traffic, and gives developer direct access to nginx via http at the same time. When use on MacOS, remember to add workspace and php-fpm to "acl purge" domains via .env config file. To install geoip2 module, you have to put your maxmind AccountID and LicenseKey in varnish/etc/GeoIP.conf before building the proxy image.

Import /local/<your_env>/volumes/ssl/certs/ca.pem as root certificate for https access.

xDebug can be enabled by uncommenting in ext-xdebug.ini in workspace and php-fpm. You canot use vim but editors that won't create a new file after saving like nano to edit the ext-xdebug.ini files to enable or disable xdebug.

Xhgui profiling can be enabled by removing comment mark at nginx/conf_m2/magento2.conf:169 and uncomment workspace/tideways_xhprof.ini or php-fpm/tideways_xhprof.ini to enable tideways module. Note that after containers have been started up, you canot use vim but editors that won't create a new file after saving like nano to edit the config files to enable or disable tideways.

Xhgui sampling rate can be changed in xhgui/config/config.php:63

Website domains should also be configured in /nginx/sites/app.conf when using nginx server.

Magento 2 multi-websites can be enabled in /nginx/conf_m2/magento2.conf.

Cron job path is configured in /workspace/crontab/laradock.
