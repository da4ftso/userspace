#!/bin/bash

# Chrome handlers
/usr/bin/defaults write com.google.Chrome ExternalProtocolDialogShowAlwaysOpenCheckbox -bool true

# Chrome native print dialog (still work in 79+ ?)
/usr/bin/defaults write com.google.Chrome DisablePrintPreview -boolean true
