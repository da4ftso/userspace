#!/bin/bash

## This allows you to specify lists of items to remove and add in arrays, and then they'll be done in bulk using a for loop
## Items to remove should be the label (usually the name of the application)
## Items to add are the full path to the item to add (usually /Applications/NAMEOFAPP.app)
## A few examples are prepopulated in the arrays, but feel free to tweak as suits the needs of your organization

# original https://raw.githubusercontent.com/aysiu/Mac-Scripts-and-Profiles/master/DockutilAddRemoveArrays.sh
# bash string manipulations here https://www.tldp.org/LDP/LG/issue18/bash.html

# TO-DO: 
# ✅ check for jamf
# ✅ check for dockutil; install from jamf (or download from site)
# ✅ check for AD binding, add Directory Utility if bound
# validate new AD, ARD vs SS checks, & that add to array works as intended
# ? check OS version, add System Prefs vs System Settings
# ? check OS version, add Safari from proper location

# check for dockutil, call policy or try direct install if not present - INCOMPLETE

# if dockutil is present, bail out
# if dockutil is not present, read jss and try jamf policy first
# if jss is empty OR if jss not empty BUT dockutil still not present, try direct download
# if dockutil still not present, bail out

jss_url=$(defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url)

if [[ -n $jss_url ]]; then
	curl --output-dir /private/tmp -O https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg ;
	installer -pkg /private/tmp/dockutil-3.0.2.pkg -target / ;
	sleep 1 ;
fi

if [[ ! -e "/usr/local/bin/dockutil" ]]; then
   /usr/local/bin/jamf policy -event install-dockutil
fi

# direct DL if no jamf

if [ -e /usr/local/bin/dockutil ] ; then
	echo "dockutil installed.."
fi


itemsToRemove=(
   "Address Book"
   "App Store"
   "Books"
   "Calendar"
   "Contacts"
   "Dictionary"
   "Downloads"
   "FaceTime"
   "Freeform"
   "iBooks"
   "iPhoto"
   "iTunes"
   "Keynote"
   "Launchpad"
   "Mail"
   "Maps"
   "Messages"
   "Mission Control"
   "Music"
   "News"
   "Notes"
   "Numbers"
   "Pages"
   "Photos"
   "Podcasts"
   "Reminders"
   "Siri"
   "Stocks"
   "TextEdit"
   "TV"
)

itemsToAdd=(
   "/Applications/Google Chrome.app"
   "/Applications/Safari.app"
   "/Applications/Preview.app"
   "/Applications/Utilities/Terminal.app"
   "/Applications/System Preferences.app"
)

# check for AD binding

ADCompName=$(dsconfigad -show | awk -F'= ' '/Computer Account/{print $NF}')

if [[ -n "$ADCompName" ]]; then
    itemsToAdd+=("/System/Library/CoreServices/Applications/Directory Utility.app") # add to itemsToAdd array
fi


# check for ARD, add Screen Sharing otherwise

if [[ ! -e "/Applications/Remote Desktop.app" ]]; then
    itemsToAdd+=("/System/Library/CoreServices/Applications/Screen Sharing.app")
else
    itemsToAdd+=("/Applications/Remote Desktop.app")
fi    


for removalItem in "${itemsToRemove[@]}"
   do
      # Check that the item is actually in the Dock
      inDock=$(/usr/local/bin/dockutil --list | /usr/bin/grep "$removalItem")
      if [ -n "$inDock" ]; then
         /usr/local/bin/dockutil --remove "$removalItem" --no-restart
      fi
   done


for additionItem in "${itemsToAdd[@]}"
   do
      # Check that the item actually exists to be added to the Dock and that it isn't already in the Dock
      # Stripping path and extension code based on code from http://stackoverflow.com/a/2664746
      additionItemString=${additionItem##*/}
      additionItemBasename=${additionItemString%.*}
      inDock=$(/usr/local/bin/dockutil --list | /usr/bin/grep "$additionItemBasename")
      if [ -e "$additionItem" ] && [ -z "$inDock" ]; then
            /usr/local/bin/dockutil --add "$additionItem" --no-restart
      fi
   done

sleep 3

/usr/bin/killall Dock
