#!/bin/bash

# if arch = arm

arch=$(/usr/bin/arch)

if [ "$arch" == "arm64" ]; then
        model=$(/usr/libexec/PlistBuddy -c 'Print :0:product-name' /dev/stdin <<< "$(ioreg -arc IOPlatformDevice -k product-name)" 2> /dev/null | tr -cd '[:print:]')

else
        model=$(curl -s https://support-sp.apple.com/sp/product?cc=$(
  system_profiler SPHardwareDataType \
    | awk '/Serial/ {print $4}' \
    | cut -c 9-
) | sed 's|.*<configCode>\(.*\)</configCode>.*|\1|')
fi

echo "Setting ARD Field 3 to: $model .."
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set3 -3 "$model"
