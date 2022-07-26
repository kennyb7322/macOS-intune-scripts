#!/bin/bash

# check if wifi adapter is enabled, store result in variable
wifiCheck=$(/usr/sbin/networksetup -listallnetworkservices | /usr/bin/grep -c "*Wi-Fi")

# if wifiCheck is not 1, disable wifi
if [ $wifiCheck -ne 1 ]; then
	/usr/sbin/networksetup -setairportpower "Wi-Fi" off
    /usr/sbin/networksetup -setnetworkserviceenabled "Wi-Fi" off
    defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool false
    defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist WiFi -int 24
fi