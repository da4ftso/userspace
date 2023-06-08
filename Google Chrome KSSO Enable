#!/bin/bash

# where is the original from?
# 1.1 updated syntax and fixed typos.

# Variables
loggedInUser=$(/usr/bin/stat -f%Su "/dev/console")
loggedInUserHome=$(dscl . -read /Users/"$loggedInUser" NFSHomeDirectory | awk '{print $NF}') # will not return trailing /
tld="*.domain.tld,*.otherdwomain.tld,*.yetanotherdomain.tld" # in the original this was all caps, does that matter?

# Google Chrome
/bin/echo "*** Enable single sign-on in Google Chrome for $loggedInUser ***"
/bin/echo "Quit all Chrome-related processes"
/usr/bin/pkill -l -U "${loggedInUser}" Chrome

if [ -f "$loggedInUserHome/Library/Preferences/com.google.Chrome.plist" ]; then

    # backup current file
    /bin/cp "/Users/$loggedInUser/Library/Preferences/com.google.Chrome.plist" "/Users/$loggedInUser/Library/Preferences/com.google.Chrome.plist.backup"
    /bin/echo "Preference archived as: /Users/$loggedInUser/Library/Preferences/com.google.Chrome.plist.backup"

    /usr/bin/defaults write /Users/"$loggedInUser"/Library/Preferences/com.google.Chrome.plist AuthNegotiateDelegateWhitelist "$tld"
    /bin/echo "AuthNegotiateDelegateWhitelist set to $tld for $loggedInUser"
    /usr/bin/defaults write /Users/"$loggedInUser"/Library/Preferences/com.google.Chrome.plist AuthServerWhitelist "$tld"
    /bin/echo "AuthServerWhitelist set to $tld for $loggedInUser"
    /usr/sbin/chown "$loggedInUser" /Users/"$loggedInUser"/Library/Preferences/com.google.Chrome.plist

    # Respawn cfprefsd to load new preferences
    /usr/bin/killall cfprefsd

else

    /bin/echo "Google .plist not found for $loggedInUser"

fi
