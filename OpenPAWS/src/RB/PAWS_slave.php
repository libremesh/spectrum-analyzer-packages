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

<html>
<head>
<title>PAWS Login Page</title>

<body>

<p> <b> Enter the Latitude and Longitude (in degrees) of your location.
</p> </b>
<form name='form' method='post' action="PAWS_response.php">

<table>
<tr>
	<td> IP Address of PAWS Master: </td>
	<td> <input type="text" name="master_ip" id="master_ip" ><br/> </td>
</tr>
<tr>
	<td> Latitude: </td>
	<td> <input type="text" name="lat" id="lat" ><br/> </td>
</tr>
<tr>
	<td> Longitude: </td> 
	<td> <input type="text" name="long" id="long"><br/> </td>
</tr>
<tr>
	<td> Height of Transmitting Antenna: </td>
	<td> <input type="text" name="height" id="height"><br/> </td>
</tr>
</table>
<input type="submit" name="submit" value="Submit">  

</form>

</head>
