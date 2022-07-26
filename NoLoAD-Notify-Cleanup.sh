#!/bin/bash

# Begin DEPNotify Clean-Up
# Caffeination Clean-Up
echo "Fully caffeinated..."
/usr/bin/pkill caffeinate

# Create DEPNotify Setup doneFile.
/bin/mkdir /Library/Application\ Support/JAMF/ExtensionAttributes/
/usr/bin/touch /Library/Application\ Support/JAMF/ExtensionAttributes/com.depnotify.provisioning.done

# Clean up loginwindow and set to use AD login features

/usr/local/bin/authchanger -reset -AD     # if you plan on using the standard macOS login screen remove the -AD flag.
/usr/bin/killall -HUP loginwindow

exit 0