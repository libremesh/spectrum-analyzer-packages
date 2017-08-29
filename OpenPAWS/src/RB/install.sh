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

if [ $# -ne 1 ]
then
	echo "Usage: '$0 master' OR '$0 slave' OR '$0 remove'"
	echo && echo "Use '$0 master' to configure the device as Master device"
	echo "Use '$0 slave' to configure the device as Slave device"
	echo "Use '$0 remove' to remove all PAWS files from the device"
	exit 1
fi

if [ "$1" == "remove" ]
then
	rm -rf /PAWS
	rm /www/PAWS*
	exit 1
fi

####################### Install Dependencies ###########################
echo "Installing dependencies"
#opkg update
#opkg install bash
#echo "Bash installation complete"
#opkg install uhttpd
#echo "HTTP Server (uhttpd) installation complete"
#opkg install php5 php5-cgi
#echo "PHP5 installation complete"

########################## PAWS Setup ###################################
mkdir /PAWS

if [ "$1" == "master" ]
then
	cp PAWS_master.php /www/PAWS.php #Files for PAWS UI
	cp PAWS_response_master.php /www/PAWS_response.php
	cp PAWS_master_server.php /www/ #PHP File for HTTP server at Master for forwarding PAWS Slave messages to TVWS Database
	cp ./init_req.sh ./avail_chan_req.sh /PAWS/ #Script Files for INIT_REQ and AVAIL_SPECTRUM_REQ at PAWS Master
	cp ./PAWS_startup.sh ./PAWS_daemon.sh ./repeat_query.sh /PAWS/ #Script Files for startup initializations 
	cp ./spectrum_use_notify.sh /PAWS/ #Script file for SPECTRUM_USE_NOTIFY message
	cp ./forward_client_req.sh /PAWS/ #Script File for transferring PAWS Slave Messages to TVWS Database
	cp *.html /PAWS #Temp
	
elif [ "$1" == "slave" ]
then
	cp PAWS_slave.php /www/PAWS.php #Files for PAWS UI
	cp PAWS_response_slave.php /www/PAWS_response.php
	cp PAWS_master_server.php /www/ #Temp
	cp ./init_req.sh ./avail_chan_req_slave.sh /PAWS/
	cp ./forward_client_req.sh /PAWS/ #Temp
	cp ./PAWS_ip.txt /PAWS/ #Temp

fi

echo "#############################################################################"
echo "Configuration Complete!"
ip=`ifconfig | grep -A 1 br-lan | grep "inet addr" | cut -d ":" -f 2 | cut -d " " -f 1`
echo "#############################################################################"
echo "Reboot the system and go to 'http://$ip/PAWS.php' for configuration!"
echo "#############################################################################"

/PAWS/PAWS_daemon.sh &

########### Startup Initializations ######################################
echo "/etc/init.d/uhttpd start" > /etc/rc.local
echo "/PAWS/PAWS_startup.sh" >> /etc/rc.local
echo "/PAWS/PAWS_daemon.sh" >> /etc/rc.local
##########################################################################

