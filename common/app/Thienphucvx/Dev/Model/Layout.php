<?php
/**
 * Copyright © 2015 Thienphucvx.com. All rights reserved.
 */
namespace Thienphucvx\Dev\Model;
use Magento\Framework\Event\Observer;
use Magento\Framework\Event\ObserverInterface;
class Layout  implements ObserverInterface
{
    protected $_logger;
    public function __construct ( \Psr\Log\LoggerInterface $logger
    ) {
        $this->_logger = $logger;/**/
    }

    public function execute(\Magento\Framework\Event\Observer $observer)
    {
    	if(isset($_GET['debug_layout_block_xml'])){
	        $xml = $observer->getEvent()->getLayout()->getXmlString();

            $xml = '<root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' . $xml . '</root>';

	        $doc = new \DomDocument();
            $doc->loadXML($xml);
	        $doc->preserveWhiteSpace = false;
	        $doc->formatOutput = true;

            echo "<pre>";
            echo htmlentities($doc->saveXML());

	        exit();
    	}
    	
        return $this;
    }
}