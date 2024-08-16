Docker development environment for Magento 2

Checkout the corresponding tag based on your Magento 2 version.

To use this environment on your local env, make sure you are using Mac OS 10.14.2 or above/Windows with WSL2/Linux, at least 8G memory and Core i5 processor.

The environment config file is /local/<your_env>/.env, most variables including website domains, project path, container ports mapping and PHP version etc. can be changed in this file.

To build project, run "docker-compose build" in corresponding environment to your OS.

To start project, run "docker-compose up -d" in corresponding environment to your OS.

To start project in Mac, run "sh sync up" in corresponding environment to your OS. Run "sh sync bash" to connect to workspace container. 

In workspace container, run "su laradock" to switcher to the project owner and "cd app" to enter the project root directory.

It will mount /local/<your_env>/volumes/ssh keys to the workspace container. Be careful to not share your built containers with others.

Varnish is configured to only serve https requests for the purpose of mimicking live traffic, and gives developer direct access to nginx via http at the same time. When use on MacOS, remember to add workspace and php-fpm to "acl purge" domains via .env config file. To install geoip2 module, you have to put your maxmind AccountID and LicenseKey in varnish/etc/GeoIP.conf before building the proxy image.

Import /local/<your_env>/volumes/ssl/certs/ca.pem as root certificate for https access.

xDebug can be enabled by uncommenting in ext-xdebug.ini in workspace and php-fpm. You canot use vim but editors that won't create a new file after saving like nano to edit the ext-xdebug.ini files to enable or disable xdebug.

Xhgui profiling can be enabled by removing comment mark at nginx/conf_m2/magento2.conf:169 and uncomment workspace/xhprof.ini or php-fpm/xhprof.ini to enable tideways module. Note that after containers have been started up, you canot use vim but editors that won't create a new file after saving like nano to edit the config files to enable or disable xhprof.

Xhgui sampling rate can be changed in xhgui/config/config.php:63

Default Xhgui dashboard URL is http://xhgui.local

To use xhprof profiling, run command below in workspace as user laradock.
composer require perftools/xhgui-collector alcaeus/mongo-php-adapter mongodb/mongodb:1.15.0

Add __serialize and __unserialize to vendor/alcaeus/mongo-php-adapter/lib/Mongo/MongoId.php by copy&pate serialize and unserialize.

Copy common/config/xhgui/config.php to vendor/perftools/xhgui-collector/config/config.php

Website domains should also be configured in /nginx/sites/app.conf when using nginx server.

Magento 2 multi-websites can be enabled in /nginx/conf_m2/magento2.conf.

Cron job path is configured in /workspace/crontab/laradock.

To not let POSTFIX send emails to Mailhog, remove values of POSTFIX_SMTP_SERVER AND POSTFIX_SMTP_PORT, change value of ENABLE_MAILPIT to false.

Sometimes the self-generated SSL may have issue with integrations. In this case, change 'verifypeer' => false, 'verifyhost' => 0 in vendor/magento/framework/HTTP/Adapter/Curl.php->_config.
