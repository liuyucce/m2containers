Put this file in your <magento_root_dir>/app/code/
Run
php bin/magento module:enable MagePsycho_Easypathhints --clear-static-content
php bin/magento setup:upgrade
php bin/magento cache:flush
Go to CMS admin->STORES->Configuration->MAGEPSYCHO->General Setting
Set "Enabled" to "Yes" and click "Save Config"

create bookmark "Magento:Templates": javascript:window.location.search = 'tp=1&code=mage2'
