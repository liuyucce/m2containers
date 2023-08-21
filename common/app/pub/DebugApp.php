<?php

class DebugApp
    extends \Magento\Framework\App\Http
    implements \Magento\Framework\AppInterface {

    public function launch()
    {
        $objectManager = \Magento\Framework\App\ObjectManager::getInstance();
        $this->_state->setAreaCode(\Magento\Framework\App\Area::AREA_CRONTAB);

        define( 'GLOBAL_CONST', 1 );

        $cron = $objectManager->get(\Your\Class\Path::class);
        $cron->exec();

        return $this->_response;
    }

}
