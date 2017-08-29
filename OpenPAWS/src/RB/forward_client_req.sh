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

ip=`cat PAWS_ip.txt`
curl -H "Content-Type: application/jason" -d '{"jsonrpc":"'"$1"'","method":"'"$2"'","databaseIP":"'"NOT_DEF"'","params":{"type":"'"$3"'","version":"'"$4"'","deviceDesc":{"serialNumber":"'"$5"'","fccId":"'"$6"'","rulesetIds":["'"$7"'"]},"location":{"point":{"center":{"lattitude":"'"$8"'","longitude":"'"$9"'"}}},"antenna":{"height":"'"$10"'","heightType":"'"$11"'"}},"id":"'"$12"'"}' http://$ip/testnext4.php > avail_chan_response_slave.html
resp=`cat avail_chan_response_slave.html`
echo $resp
