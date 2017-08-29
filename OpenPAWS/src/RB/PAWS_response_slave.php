<html>
<head>
<title>
PAWS Response Page
</title>
</head>
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
if((isset($_POST['lat'])) && !empty($_POST['lat']) && (isset($_POST['long'])) && !empty($_POST['long']) && (isset($_POST['master_ip'])) && !empty($_POST['master_ip']) && (isset($_POST['height'])) && !empty($_POST['height']))
{
	$lat = $_POST['lat']; 
	$long = $_POST['long'];
	$master_ip = $_POST['master_ip'];
	$ht = $_POST['height'];
	$old_path=getcwd();
	chdir('/PAWS/');
	$output=shell_exec("./avail_chan_req_slave.sh $lat $long $master_ip $ht");
	chdir($old_path);
	echo $output;
}
else
{
	echo "Enter IP Address, Latitude and Longitude";
}
?>
</html>
