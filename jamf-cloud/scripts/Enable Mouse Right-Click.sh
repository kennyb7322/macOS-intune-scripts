#!/bin/bash

# Look for User accounts

Accounts=$(ls -l /Users | /usr/bin/awk '{print $9}' | /usr/bin/grep -viE '(shared|Guest|.DS_Store|.localized)')

for UserAccounts in $Accounts

do

/usr/bin/defaults write /Users/$UserAccounts/Library/Preferences/com.apple.driver.AppleHIDMouse.plist Button2 -int 2

done