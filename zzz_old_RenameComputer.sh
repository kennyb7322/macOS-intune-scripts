#!/bin/sh

serial=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')
response=$(curl -k -H "accept: application/xml" -u 'renametestuser:d3$kt0p' https://nhcs650.jamfcloud.com:443/JSSResource/computers/serialnumber/${serial}/subset/general)
assetTag=$(echo $response | /usr/bin/awk -F'<asset_tag>|</asset_tag>' '{print $2}');
barcode1=$(echo $response | /usr/bin/awk -F'< barcode_1 >|</barcode_1 >' '{print $2}');
barcode2=$(echo $response | /usr/bin/awk -F'< barcode_2 >|</barcode_2 >' '{print $2}');

computerName='NHCS-'$assetTag'-MAC-'$serial
# Setting computername
echo "Setting computer name..."
scutil --set ComputerName "$computerName"
scutil --set HostName "$computerName"
scutil --set LocalHostName "$computerName"

exit 0