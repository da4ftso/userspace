#!/bin/bash

# query the anyconnect binary, check for work LAN IP, check for work monitor
# Do Things if it returns Connected
# bail out if Disconnected

# call this from a LA since only running when logged in & user initiates VPN
# for the fleet, jamf log?
# for me, run a shortcut

# wireless_ip=$(/usr/sbin/ipconfig getifaddr en0)

ac=/opt/cisco/anyconnect/bin/vpn
sc=/opt/cisco/secureclient/bin/vpn

if [ -e $ac ]; then

	state=$($ac state | /usr/bin/awk '/state: / { print $NF ; exit } ')
	
elif [ -e $sc ]; then

	state=$($sc state | /usr/bin/awk '/state: / { print $NF ; exit } ')
	
fi

display=$(/usr/sbin/ioreg -p IOUSB -w0 | grep "Studio Display")

# if [[ "${state}" = "Connected" || "${wireless_ip}" =~ /^[1][0][.][7]/gm || -n "${display}" ]]; then

if [[ "${state}" = "Connected" || -n "${display}" ]]; then

	/usr/bin/shortcuts run "At Work"

	sleep="y"

	while [ "$sleep" = "y" ]; do

		sleep 30

		state=$(/opt/cisco/anyconnect/bin/vpn state | /usr/bin/awk '/state: / { print $NF ; exit } ')
		display=$(/usr/sbin/ioreg -p IOUSB -w0 | grep "Studio Display")

		if [[ "${state}" = "Disconnected" || ! -n "${display}" ]]; then

			/usr/bin/shortcuts run "Off Network"

			sleep="n"

		fi

	done

else

	exit 0

fi
