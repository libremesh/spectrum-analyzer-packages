#!/bin/bash
##########################################################################
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
##########################################################################

lat=$1
long=$2
database=$3
ht=$4
hwAddr=$(ifconfig | grep eth0 | cut -d " " -f 11)

echo "Latitude=$1" > /PAWS/config.cfg
echo "Longitude=$2" >> /PAWS/config.cfg
echo "PAWS_IP=$3" >> /PAWS/config.cfg
echo "HAAT=$4" >> /PAWS/config.cfg

curl -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"spectrum.paws.init","params":{"type":"INIT_REQ", "version":"1.0","deviceDesc":{"serialNumber":"'"$hwAddr"'","fccId":"YYY","rulesetIds":["FccTvBandWhiteSpace-2010"]}, "location":{"point":{"center":{"lattitude":"'"$lat"'","longitude":"'"$long"'"}}}},"id": "xxxxxx"}' http://$database/init.php > /PAWS/init_resp.html

status=`cat /PAWS/init_resp.html | grep -o \"type\"\:\"[A-Z_]*\" | cut -d ":" -f2`

if [ "$status" == "\"INIT_RESP\"" ]
then
	maxpol=`cat /PAWS/init_resp.html | grep -o \"maxPollingSecs\"\:[0-9]* | cut -d ":" -f 2`
	echo "Max_Pol=$maxpol" >> /PAWS/config.cfg
	echo "Initialization successful.<br />"
	echo "Querying database for the list of available channels.<br/><br/>"
	/PAWS/avail_chan_req.sh $1 $2 $3 $4
else 
	echo "PAWS Initialization failed. Exiting."
fi


