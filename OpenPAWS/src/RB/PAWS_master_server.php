<!--##########################################################################
#    Implementation of PAWS on Openwrt
#    Information Networks Lab, Department of Electrical Engineering, 
#    Indian Institute of Technology Bombay.
#    This file copyright 2014-2015 Gaurang Naik and Soumik Ghosh.
#    
#    This program is free software; you can redistribute it and/or
#    modify it under the terms of the GNU General Public License as
#    published by the Free Software Foundation; either version 2 of the
#    License, or (at your option) any later version.  See the file
#    COPYING included with this distribution for more information.
########################################################################## -->

<?php

/*include("/var/www/html/testdatabaseaccess.php");

$cxn = mysql_connect('localhost','root','123456');
if( $cxn === FALSE ) {  die('mysql connection error: '.mysql_error()); }
*/

$json = file_get_contents('php://input');
$data = json_decode($json);

$jsonrpc= $data->jsonrpc;
$method= $data->method;
$type= $data->params->type;
$version= $data->params->version;
$serialNumber= $data->params->deviceDesc->serialNumber;
$fccId= $data->params->deviceDesc->fccId;
$rulesetIds= $data->params->deviceDesc->rulesetIds;
$lat= $data->params->location->point->center->lattitude;
$long= $data->params->location->point->center->longitude;
$height= $data->params->antenna->height;
$heightType= $data->params->antenna->heightType;
$id= $data->id;

//Received data from slave device... Sending to master
$data_string=json_encode($data);

$old_path=getcwd();
chdir('/root/PAWS');
$output=shell_exec("./forward_client_req.sh $jsonrpc $method $type $version $serialNumber $fccId $rulesetIds $lat $long $height $heightType $id"); //Execute forward message script with json encoded data
chdir($old_path);        

echo $output; //Send back to slave
?>
