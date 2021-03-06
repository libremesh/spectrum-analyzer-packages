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
hwAddr=$(ifconfig | grep eth0 | cut -d " " -f 11)
ht=$4

curl -H "Content-Type: application/jason" -d '{"jsonrpc":"2.0","method":"spectrum.paws.getSpectrum","params":{"type":"AVAIL_SPECTRUM_REQ","version":"1.0","deviceDesc":{"serialNumber":"'"hwAddr"'","fccId":"YYY","rulesetIds":["FccTvBandWhiteSpace-2010"]},"location":{"point":{"center":{"lattitude":"'"$lat"'","longitude":"'"$long"'"}}},"antenna":{"height":"'"$ht"'","heightType": "AGL"}},"id": "xxxxxx"}' http://$database/PAWS_master_server.php > avail_spectrum_resp_slave.html 
#The PAWS protocol does not specify communication between slave and master device. The "databaseIP" field has been added additionally. 

no_chan_avail=$(cat avail_spectrum_resp_slave.html | grep -o "hz" | wc -l)
echo "Number of TV channels available are $no_chan_avail ------"
if [ $no_chan_avail = 0 ]
then
	echo "Exiting "
	exit 0
fi

channels=$(cat avail_spectrum_resp_slave.html | grep -o "....e8" | cut -d "e" -f 1)
#echo $channels

echo "Now calculating WiFi channels ------"

for i in $channels
#for i in "${channels[@]}"
do
    if [ "$i" = "5.26" ] ; then
        chan21=yes
    fi
    if [ "$i" = "5.34" ]; then
	chan22=yes
    fi
    if [ "$i" = "5.42" ]; then
	chan23=yes
    fi
    if [ "$i" = "5.50" ] ; then
        chan24=yes
    fi
    if [ "$i" = "5.58" ] ; then
        chan25=yes
    fi
    if [ "$i" = "5.66" ] ; then
        chan26=yes
    fi
    if [ "$i" = "5.74" ] ; then
        chan27=yes
    fi
    if [ "$i" = "5.82" ] ; then
        chan28=yes
    fi

    if [ "$chan21" == "yes" -a "$chan22" == "yes" -a "$chan23" == "yes" ]
    then
	WiFiChan1=1
    fi
    if [ "$chan21" == "yes" -a "$chan22" == "yes" -a "$chan23" == "yes" -a "$chan24" == "yes" ]
    then
        WiFiChan2=1
    fi
    if [ "$chan22" == "yes" -a "$chan23" == "yes" -a "$chan24" == "yes" -a "$chan25" == "yes" ]
    then
        WiFiChan3=1
    fi
    if [ "$chan23" == "yes" -a "$chan24" == "yes" -a "$chan25" == "yes" ]
    then
        WiFiChan4=1
    fi
    if [ "$chan24" == "yes" -a "$chan25" == "yes" -a "$chan26" == "yes" ]
    then
        WiFiChan5=1
    fi
    if [ "$chan24" == "yes" -a "$chan25" == "yes" -a "$chan26" == "yes" -a "$chan27" == "yes" ]
    then
        WiFiChan6=1
    fi
    if [ "$chan25" == "yes" -a "$chan26" == "yes" -a "$chan27" == "yes" ]
    then
        WiFiChan7=1
    fi
    if [ "$chan25" == "yes" -a "$chan26" == "yes" -a "$chan27" == "yes" -a "$chan28" == "yes" ]
    then
        WiFiChan8=1
    fi
    if [ "$chan26" == "yes" -a "$chan27" == "yes" -a "$chan28" == "yes" ]
    then
        WiFiChan9=1
    fi
done


if [ "$WiFiChan1" == "1" ]
then
	echo Channel 1 available ------
fi
if [ "$WiFiChan2" = "1" ]                                                                          
then                                                                                           
        echo Channel 2 available ------                                                        
fi
if [ "$WiFiChan3" = "1" ]                                                                          
then                                                                                           
        echo Channel 3 available ------                                                        
fi
if [ "$WiFiChan4" = "1" ]                                                                          
then                                                                                           
        echo Channel 4 available ------                                                              
fi
if [ "$WiFiChan5" = "1" ]                                                                          
then                                                                                           
        echo Channel 5 available ------                                                              
fi
if [ "$WiFiChan6" = "1" ]                                                                          
then                                                                                           
        echo Channel 6 available ------                                                              
fi
if [ "$WiFiChan7" = "1" ]                                                                          
then                                                                                           
        echo Channel 7 available ------                                                              
fi
if [ "$WiFiChan8" = "1" ]                                                                          
then                                                                                           
        echo Channel 8 available ------                                                              
fi
if [ "$WiFiChan9" = "1" ]                                                                          
then                                                                                           
        echo Channel 9 available ------                                                              
fi

if [ $WiFiChan1 = 1 ]                                                                          
then                                                                                                                                            
        cat avail_spectrum_resp_slave.html | grep -o 5.26e8.......... | cut -d ":" -f 2 > t
        cat avail_spectrum_resp_slave.html | grep -o 5.34e8.......... | cut -d ":" -f 2 >> t
        cat avail_spectrum_resp_slave.html | grep -o 5.42e8.......... | cut -d ":" -f 2 >> t
        power=$(cat t | sort -u | awk 'BEGIN{t=0}{if(t==0) print; t=t+1}')
#        uci set wireless.radio0.txpower=$power
#        uci set wireless.radio0.channel=1
        echo Channel set to 1 ------  
        echo Tx-Power set to $power dBm ------
        rm t                                                            
elif [ $WiFiChan2 = 1 ]                                                                                                          
then                                                                                           
	 cat avail_spectrum_resp_slave.html | grep -o 5.26e8.......... | cut -d ":" -f 2 > t
	 cat avail_spectrum_resp_slave.html | grep -o 5.34e8.......... | cut -d ":" -f 2 >> t
	 cat avail_spectrum_resp_slave.html | grep -o 5.42e8.......... | cut -d ":" -f 2 >> t
	 power=$(cat t | sort -u | awk 'BEGIN{t=0}{if(t==0) print; t=t+1}')
#	 uci set wireless.radio0.txpower=$power
#	 uci set wireless.radio0.channel=2
	 echo Channel set to 2 ------
	 echo Tx-Power set to $power dBm ------
	 rm t
elif [ $WiFiChan3 = 1 ]                                                                          
then                                                                                           
	 cat avail_spectrum_resp_slave.html | grep -o 5.26e8.......... | cut -d ":" -f 2 > t
	 cat avail_spectrum_resp_slave.html | grep -o 5.34e8.......... | cut -d ":" -f 2 >> t
	 cat avail_spectrum_resp_slave.html | grep -o 5.42e8.......... | cut -d ":" -f 2 >> t
	 power=$(cat t | sort -u | awk 'BEGIN{t=0}{if(t==0) print; t=t+1}')
#	 uci set wireless.radio0.txpower=$power
#	 uci set wireless.radio0.channel=3
	 echo Channel set to 3 ------
	 echo Tx-Power set to $power dBm ------
	 rm t                                                             
elif [ $WiFiChan4 = 1 ]                                                                          
then                                                                                           
	 cat avail_spectrum_resp_slave.html | grep -o 5.26e8.......... | cut -d ":" -f 2 > t 
         cat avail_spectrum_resp_slave.html | grep -o 5.34e8.......... | cut -d ":" -f 2 >> t
         cat avail_spectrum_resp_slave.html | grep -o 5.42e8.......... | cut -d ":" -f 2 >> t
         power=$(cat t | sort -u | awk 'BEGIN{t=0}{if(t==0) print; t=t+1}')                 
#         uci set wireless.radio0.txpower=$power
#	 uci set wireless.radio0.channel=4
	 
	 echo Channel set to 4 ------                                                     
	 echo Tx-Power set to $power dBm ------
	 rm t
elif [ $WiFiChan5 = 1 ]                                                                          
then                                                                                           
	 cat avail_spectrum_resp_slave.html | grep -o 5.26e8.......... | cut -d ":" -f 2 > t 
         cat avail_spectrum_resp_slave.html | grep -o 5.34e8.......... | cut -d ":" -f 2 >> t
         cat avail_spectrum_resp_slave.html | grep -o 5.42e8.......... | cut -d ":" -f 2 >> t
         power=$(cat t | sort -u | awk 'BEGIN{t=0}{if(t==0) print; t=t+1}')                 
#	 uci set wireless.radio0.txpower=$power
#	 uci set wireless.radio0.channel=5  
	 echo Channel set to 5 ------
	 rm t                                                  
	 echo Tx-Power set to $power dBm ------
elif [ $WiFiChan6 = 1 ]                                                                          
then                                                                                           
	 cat avail_spectrum_resp_slave.html | grep -o 5.26e8.......... | cut -d ":" -f 2 > t 
         cat avail_spectrum_resp_slave.html | grep -o 5.34e8.......... | cut -d ":" -f 2 >> t
         cat avail_spectrum_resp_slave.html | grep -o 5.42e8.......... | cut -d ":" -f 2 >> t
         power=$(cat t | sort -u | awk 'BEGIN{t=0}{if(t==0) print; t=t+1}')                 
#         uci set wireless.radio0.txpower=$power
#	 uci set wireless.radio0.channel=6
	 echo Channel set to 6 ------
	 echo Tx-Power set to $power dBm ------
	 rm t
elif [ $WiFiChan7 = 1 ]                                                                          
then                                                                                           
	 cat avail_spectrum_resp_slave.html | grep -o 5.26e8.......... | cut -d ":" -f 2 > t 
         cat avail_spectrum_resp_slave.html | grep -o 5.34e8.......... | cut -d ":" -f 2 >> t
         cat avail_spectrum_resp_slave.html | grep -o 5.42e8.......... | cut -d ":" -f 2 >> t
         power=$(cat t | sort -u | awk 'BEGIN{t=0}{if(t==0) print; t=t+1}')                 
 #        uci set wireless.radio0.txpower=$power
#	 uci set wireless.radio0.channel=7
	 echo Channel set to 7 ------     
	 echo Tx-Power set to $power dBm ------
	 rm t                                              
elif [ $WiFiChan8 = 1 ]                                                           
then                                                                                           
	 cat avail_spectrum_resp_slave.html | grep -o 5.26e8.......... | cut -d ":" -f 2 > t 
         cat avail_spectrum_resp_slave.html | grep -o 5.34e8.......... | cut -d ":" -f 2 >> t
         cat avail_spectrum_resp_slave.html | grep -o 5.42e8.......... | cut -d ":" -f 2 >> t
         power=$(cat t | sort -u | awk 'BEGIN{t=0}{if(t==0) print; t=t+1}')                 
#	 uci set wireless.radio0.txpower=$power
#	 uci set wireless.radio0.channel=8   
	 echo Channel set to 8 ------     
	 echo Tx-Power set to $power dBm ------
	 rm t                                             
elif [ $WiFiChan9 = 1 ]                                                                          
then                                                                                           
	 cat avail_spectrum_resp_slave.html | grep -o 5.26e8.......... | cut -d ":" -f 2 > t 
         cat avail_spectrum_resp_slave.html | grep -o 5.34e8.......... | cut -d ":" -f 2 >> t
         cat avail_spectrum_resp_slave.html | grep -o 5.42e8.......... | cut -d ":" -f 2 >> t
         power=$(cat t | sort -u | awk 'BEGIN{t=0}{if(t==0) print; t=t+1}')                 
#         uci set wireless.radio0.txpower=$power
#	 uci set wireless.radio0.channel=9
	 echo Channel set to 9 ------                                                                                        
	 echo Tx-Power set to $power dBm ------
	 rm t
fi           
echo Restarting network 
#/etc/init.d/network restart

#iw dev wlan0 info
