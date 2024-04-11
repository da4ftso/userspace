#!/bin/zsh

plutil -create xml1 Info.plist # create an empty file [optional]

# insert an empty array
plutil -insert ArrayName -array Info.plist 

# append a string to the array
plutil -insert ArrayName -string hidden -append Info.plist 
