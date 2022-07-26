#!/bin/bash

sudo /Library/Application\ Support/Adobe/Adobe\ Desktop\ Common/HDBox/Setup --uninstall=1 --sapCode=PPRO --baseVersion=15.0 --platform=osx10-64 --deleteUserPreferences=false

exit 0; ## Success
exit 1; ## Failure