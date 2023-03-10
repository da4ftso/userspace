#!/bin/bash

## This allows you to specify lists of items to remove and add in arrays, and then they'll be done in bulk using a for loop
## Items to remove should be the label (usually the name of the application)
## Items to add are the full path to the item to add (usually /Applications/NAMEOFAPP.app)
## A few examples are prepopulated in the arrays, but feel free to tweak as suits the needs of your organization

# original https://raw.githubusercontent.com/aysiu/Mac-Scripts-and-Profiles/master/DockutilAddRemoveArrays.sh
# bash string manipulations here https://www.tldp.org/LDP/LG/issue18/bash.html

# TO-DO: 
# - check for jamf
# - check for dockutil; install from jamf or site
# - check for AD binding, add Directory Utility if bound
# - check OS version, add System Prefs vs System Settings
# - check OS version, add Safari from proper location

itemsToRemove=(
   "Address Book"
   "App Store"
   "Books"
   "Calendar"
   "Contacts"
   "Dictionary"
   "Downloads"
   "FaceTime"
   "Freehand"
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
      inDock=$(/usr/local/bin/dockutil --list | /usr/bin/grep "additionItemBasename")
      if [ -e "$additionItem" ] && [ -z "$inDock" ]; then
            /usr/local/bin/dockutil --add "$additionItem" --no-restart
      fi
   done

sleep 3

/usr/bin/killall Dock
