#!/bin/bash

# query the cisco vpn binary (anyconnect 4, secureclient 5)
# Do Things if it returns 'Connected'
# do Other Things out if 'Disconnected'

# call this from a LA since only running when logged in & user initiates VPN
# for the fleet, jamf log?
# for me, run a shortcut

# also let's change state to a function

ac=/opt/cisco/anyconnect/bin/vpn
sc=/opt/cisco/secureclient/bin/vpn

if [ -e $ac ]; then

	vpn=$ac
	
elif [ -e $sc ]; then

	vpn=$sc
	
fi	

state=$($vpn status | grep -v 'Unknown' | /usr/bin/awk '/state: / { print $NF ; exit } ')

if [ "${state}" = "Connected" ]; then

	/usr/bin/shortcuts run "At Work"

	sleep="y"

	while [ "$sleep" = "y" ]; do

		sleep 30

		state=$($vpn status | grep -v 'Unknown' | /usr/bin/awk '/state: / { print $NF ; exit } ')
		
		if [ "${state}" = "Disconnected" ]; then

			/usr/bin/shortcuts run "Off Network"

			sleep="n"

		fi

	done

else

	exit 0

fi
