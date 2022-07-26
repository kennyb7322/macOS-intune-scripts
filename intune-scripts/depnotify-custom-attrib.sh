#!/bin/sh
var=$(ls /usr/local/depnotify-with-installers/DEPNotify.pkg)
if [ -z "$var" ]; then
    echo "depnotify NO"
else
    echo "depnotify YES"
fi