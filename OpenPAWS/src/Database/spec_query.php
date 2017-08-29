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

//var_dump($data);
$p= $data->params->location->point->center->lattitude;
$q= $data->params->location->point->center->longitude;
$r= $data->method;
$MAC= $data->params->deviceDesc->serialNumber;
//echo $p;

if($p+.5 > $p+1)
$p=$p+1;
if($q+.5 > $q+1)
$q=$q+1;

//print_r($data);

$link = mysql_connect('localhost', 'root', '123456');

if (!$link) {
    die('Not connected : ' . mysql_error());
}

// make testdatabase the current db
$db_selected = mysql_select_db('testdatabase', $link);
if (!$db_selected) {
    die ('Can\'t use testdatabase : ' . mysql_error());
}

$return_arr = array();

$result = mysql_query("SELECT * FROM tvws WHERE lattitude = '$p' AND longitude = '$q'");
if (!$result) {
    echo 'Could not run query: ' . mysql_error();
    exit;
}
$row = mysql_fetch_row($result);

$starttime=$row[6];
$endtime=$row[7];
$new_ch = $row[8];
$new_tx = $row[4];
//echo "channel value : $new_ch";

$mac_add_repository = mysql_query("SELECT * FROM repository WHERE lattitude = '$p' AND longitude = '$q'");

if("$r"=="spectrum.paws.getSpectrum") {
print_r("success1");

if("$MAC"=="$mac_add_repository")
{
print_r("success2");

$array_send = array();
$array_send = <<<EOT
{
    "jsonrpc": "2.0",
    "result": {
     "type": "AVAIL_SPECTRUM_RESP",
     "version": "1.0",
     "timestamp": "date:time",
     "deviceDesc": {
      "serialNumber": "MAC",
      "fccId": "PAWS-IND",
      "rulesetIds": ["FccTvBandWhiteSpace-2010"]
     },
     "spectrumSpecs": [
      {
       "rulesetInfo": {
         "authority": "IIT BOMBAY",
         "rulesetId": "FccTvBandWhiteSpace-2010"
       },
       "needsSpectrumReport": false,
       "spectrumSchedules": [
        {
         "eventTime": {
          "startTime": "date:starttime",
          "stopTime": "date:endtime"
         },
         "spectra": []
        },
        {
         "eventTime": {
          "startTime": "2013-03-02T22:00:00Z",
          "stopTime": "2013-03-03T14:30:21Z"
         },
         "spectra": []
        }
       ]
      }
     ]
    },
    "id": "xxxxxx"
   }
EOT;

$new_json_array = json_decode($array_send);

//print_r($new_json_array);
$channel_array = split(",", $new_ch);
$tx_power_array= split(",", $new_tx);

$new_channel_array = array();
$i=-1;

foreach($channel_array as $channel){
	if($channel != NULL) {
		$i= $i+1;
		array_push($new_channel_array, array("hz"=>$channel, "dbm"=>$tx_power_array[$i]));
	}
}
$profile = array("resolutionBwHz"=>6000000, "profiles"=>$new_channel_array);
//print_r($new_json_array->result->spectrumSpecs[0]->spectrumSchedules[0]);
array_push($new_json_array->result->spectrumSpecs[0]->spectrumSchedules[0]->spectra, $profile); 

//print_r($new_json_array->result->spectrumSpecs[0]->spectrumSchedules[0]->spectra[0]);

print_r(json_encode($new_json_array));

}
else{

$Err_send = <<<EOT
 {
     "jsonrpc": "2.0",
     "error": {
       "code": -102,
       "message": "The Database does not support the device.",
       
     },
     "id": "idString"
   }
}
EOT;
print_r("failure0");
print_r(json_decode(json_encode($Err_send)));
//$newerrorarray = json_decode($Err_send);
//print_r(json_encode($newerrorarray));
exit();
}
}
else
{

$Error_send = <<<EOT
 {
     "jsonrpc": "2.0",
     "error": {
       "code": -202,
       "message": "The Request you have made is invalid."
       "data": { ... }
     },
     "id": "idString"
   }
}
EOT;
print_r("failure1");
print_r(json_decode(json_encode($Error_send)));
//$errorarray = json_decode($Error_send);
//print_r(json_encode($errorarray));
exit();
}
/*

echo json_encode($return_arr);
*/
?>
