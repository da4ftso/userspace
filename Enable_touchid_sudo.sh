#!/bin/bash

if [[ `grep tid /etc/pam.d/sudo` ]]

then

echo "TouchID already enabled"

else

sed -i '' '1 a\
auth sufficient pam_tid.so\
' /etc/pam.d/sudo

echo "Enabling TouchID for sudo";

fi
