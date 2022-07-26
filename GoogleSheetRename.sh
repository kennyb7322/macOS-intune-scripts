#!/bin/sh
## postinstall

# the Google Sheet identifier from the published URL 
sheetID="1lx56qFvQqcAg6-Qgc_nDQoPLhirANfQHG1JPejopEl8"


# letter designation of the column in the sheet for the device serial numbers
# if following the default format from an Apple School Manager export this will be A
serialCol="A"

# letter designation of the colum in the sheet for the custom device name
nameCol="B"

# get the device serial number
serialNumber=$(/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/Serial/ {print $4}')

# uncomment for debug
# echo $serialNumber

#Look up serial number from Google Sheet using the Google visualization api
dname=$(curl --silent "https://docs.google.com/spreadsheets/d/$sheetID/gviz/tq?tqx=out:csv&tq=%20select%20$nameCol%20WHERE%20$serialCol%3D%27$serialNumber%27")

# Remove the header information and use quotes
dname=$(echo $dname | cut -d '"' -f 2)

# uncomment for debug
# echo $dname

#Test to see if the name return has zero length and use serial number instead
if test -z $dname
then 
dname=$serialNumber 
fi

# uncomment for debug
#echo $dname

# Name the device using best value
/usr/local/bin/jamf setComputerName -name "$dname"
scutil --set ComputerName "$dname"
scutil --set HostName  "$dname"
dscacheutil -flushcache

exit 0      ## Success