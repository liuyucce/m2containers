<?php
require __DIR__ . '/../app/bootstrap.php';
include "./DebugApp.php";

$bootstrap = \Magento\Framework\App\Bootstrap::create(BP, $_SERVER);
$app = $bootstrap->createApplication(\DebugApp::class);
$bootstrap->run($app);