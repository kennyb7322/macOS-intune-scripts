#!/bin/sh

# Set the Notify mechanism to launch before the login screen
/usr/local/bin/authchanger -reset -preLogin NoMADLoginAD:Notify

# Configure the look of the placeholder Notify panel
/bin/echo "Command: Image: "/usr/local/depnotify-with-installers/nhcs-banner.png"" >> /var/tmp/depnotify.log
/bin/echo "Command: MainTitle: Please wait a moment..." >> /var/tmp/depnotify.log
/bin/echo "Command: MainText: " >> /var/tmp/depnotify.log
/bin/echo "Status: Please wait..." >> /var/tmp/depnotify.log