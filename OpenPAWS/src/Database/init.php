
<?php
/*##########################################################################
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
##########################################################################*/

$json = file_get_contents('php://input');
$data = json_decode($json);

$p= $data->params->location->point->center->lattitude;
$q= $data->params->location->point->center->longitude;
$MAC= $data->params->deviceDesc->serialNumber;

$p= round($p, 2);
$q= round($q, 2);

$return_arr = array();

$row = mysql_fetch_row($result);
$new_ch = $row[8];

// Create connection
$conn = new mysqli('localhost','root','123456','testdatabase');
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "INSERT INTO repository ( MAC, lattitude, longitude )  VALUES   ( '$MAC', '$p', '$q' )";
$result = $conn->query($sql);

//$conn->close();


//echo "channel value : $new_ch";
$array_send = array();
$array_send = <<<EOT
{
"jsonrpc": "2.0",
"result": {
"type": "INIT_RESP",
"version": "1.0",
"rulesetInfos": [
{
"authority": "IIT-Bombay",
"rulesetId": "FccTvBandWhiteSpace-2010",
"maxLocationChange": 100,
"maxPollingSecs": 86400
}
]
},
"id": "xxxxxx"
}
EOT;
$new_json_array = json_decode($array_send);

print_r(json_encode($new_json_array));

?>
