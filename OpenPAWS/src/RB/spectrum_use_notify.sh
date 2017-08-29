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

lat=`cat config.cfg| grep Latitude | cut -d "=" -f2`
long=`cat config.cfg| grep Longitude | cut -d "=" -f2`
ip=`cat config.cfg| grep PAWS_IP |cut -d "=" -f2`
ht=`cat config.cfg| grep HAAT | cut -d "=" -f2`
chan=`cat config.cfg | grep Channel | cut -d "=" -f 2`
txpower=`cat config.cfg | grep txpower | cut -d "=" -f 2`

curl -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"spectrum.use.notify","params":{"type":"SPECTRUM_USE_NOTIFY", "version":"1:.0","deviceDesc":{"serialNumber":"'"$hwAddr"'","fccId":"YYY","rulesetIds":["FccTvBandWhiteSpace-2010"]}, "location":{"point":{"center":{"lattitude":"'"$lat"'","longitude":"'"$long"'"}}}, "antenna":{"height":"'"$ht"'","heightType": "AGL"}},"channel":"'"$chan"'","txpower""'"$txpower"'","id": "xxxxxx"}' http://$database/spectrum_use.php > /PAWS/spectrum_notify_resp.html
