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
cd /PAWS/
if [ -f "config.cfg" ]; then
	chan=`cat config.cfg | grep Channel | cut -d "=" -f 2`
	txpower=`cat config.cfg | grep txpower | cut -d "=" -f 2`
	uci set wireless.radio0.channel=$chan
	uci set wireless.radio0.channel=$txpower
	uci commit wireless
	wifi up
fi

