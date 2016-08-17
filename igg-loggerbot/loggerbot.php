<?php
$dt = new DateTime;
$lognm = $_GET['logid'] or die("Parameter error.");
$logtxt = $dt->format(DateTime::ATOM) . ': ' . file_get_contents('php://input');
echo $logtxt;
$myfile = file_put_contents('log-' . $lognm . '.txt', $logtxt.PHP_EOL , FILE_APPEND);
 
?>