#!/bin/bash

# Bonjour Name Maximum Length – 63 Characters
# The maximum length of the host name and of the fully qualified domain name (FQDN) is 63 bytes per label and 255 bytes per FQDN. Note – Windows does not permit computer names that exceed 15 characters, and you cannot specify a DNS host name that differs from the NETBIOS host name.
# 
# DNS limits the length of each label in RFC 1035 – however, that limit is actually 63. Both in RFC 1035 section 2.3.1 and as clarified in RFC 2181 section 11.
# 
# http://tools.ietf.org/html/rfc1035
# http://tools.ietf.org/html/rfc1035#section-2.3.1
# http://tools.ietf.org/html/rfc2181#section-11
#
# Bonjour Name – Allowed Characters
# The Internet standards for protocols mandate that component hostname labels may contain only the ASCII letters ‘a’ through ‘z’ (in a case-insensitive manner), the digits ‘0’ through ‘9’, and the hyphen (‘-‘).
# 
# -
# 0123456789
# abcdefghijklmnopqrstuvwxyz
# The original specification of hostnames in RFC 952, mandated that labels could not start with a digit or with a hyphen, and must not end with a hyphen. However, a subsequent specification (RFC 1123) permitted hostname labels to start with digits. No other symbols, punctuation characters, or white space are permitted.
#
# Using scutil to set LocalHostName will fail if there is any illegal character.


COMPUTERNAME=$1

VALIDNAME=$(echo ${COMPUTERNAME//[^a-zA-Z0-9]/-}) # Shell expansion avoids tr or sed.

# Check for root.

if /bin/test $(/usr/bin/id -u) -ne 0
then
	echo "Error: This script must be run as root."
	exit 1
fi


# Check for argument passed. If this were sh we'd have to use [..] and quotes: "$1" == ""

if [[ -z $1 ]]; then
	echo "No name provided, exiting.."	
	exit 1
fi	


# Set Hostname using variable created above
scutil --set HostName $COMPUTERNAME
scutil --set ComputerName $COMPUTERNAME
scutil --set LocalHostName $VALIDNAME


# If the two names matched, we could set like this:
#
# for i in HostName ComputerName LocalHostName; do
#     scutil --set $i $COMPUTERNAME
# done


# Return each value on its own line with a label.

for i in HostName ComputerName LocalHostName; do
	/usr/bin/printf "$i='%s'\n" "$(/usr/sbin/scutil --get $i)"
done
