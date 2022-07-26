#!/bin/bash
mkdir -p "/Library/Application Support/OpenDNS Roaming Client/"
DATA='<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>APIFingerprint</key>
<string>24d095643b08123ddc1887714bc68868</string>
<key>APIOrganizationID</key>
<string>1933448</string>
<key>APIUserID</key>
<string>7798624</string>
<key>InstallMenubar</key>
<true/>
</dict>
</plist>'
echo "$DATA" > "/Library/Application Support/OpenDNS Roaming Client/OrgInfo.plist"