#!/bin/bash

#################################################################################
#
# This script is developed from the Jamf DEPNotify Starter script for use with NoLoAD's Notify features.
# It triggers the Notify screen after login with AD credentials then runs policies based on the array below.
# This script is sanitized and free to use through the MIT License, any improvements are greatly appreciated.
# Feel free to comment or create a pull request.
#
# Copyright (c) 2019 Vince Mascoli (@PaperFixie)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
###############################################################################


# Ensuring that the authchanger command is set to implement the notify window
# if you wish to run the Notify screen before logging in change flag to -preAuth

/usr/local/bin/authchanger -reset -AD -preAuth NoMADLoginAD:Notify 

# Reloading the login window
/usr/bin/killall -HUP loginwindow

# Variables for File Paths
JAMF_BINARY="/usr/local/bin/jamf"
DEP_NOTIFY_CONFIG="/var/tmp/depnotify.log"
TMP_DEBUG_LOG="/var/tmp/depNotifyDebug.log"

#########################################################################################
# Variables to Modify
#########################################################################################
# Testing flag will enable the following things to change:
# - Auto removal of BOM files to reduce errors
# - Sleep commands instead of polcies being called
# - Quit Key set to command + control + x
TESTING_MODE=false # Set variable to true or false

# Update the variable below replacing "Organization" with the actual name of your organization. Example "ACME Corp Inc."
ORG_NAME="New Hanover County Schools"

# Banner image can be 600px wide by 100px high. Images will be scaled to fit
# If this variable is left blank, the generic image will appear
BANNER_IMAGE_PATH="/private/var/nhcs/nhcs-banner.png"

# Main heading that will be displayed under the image
# If this variable is left blank, the generic banner will appear
BANNER_TITLE="$ORG_NAME - First Time Setup"

# Paragraph text that will display under the main heading. For a new line, use \n
# this variable is left blank, the generic message will appear. Leave single
# quotes below as double quotes will break the new line.
MAIN_TEXT='Welcome to your new Mac! We want you to have a few applications and settings configured before you get started. \n This process should take 10-20 minutes to complete. \n \n If you need addtional software or help, please contact the CTE Area Technical Coordinator.'

# The policy array must be formatted "Progress Bar text,customTrigger". These will be
# run in order as they appear below.
  POLICY_ARRAY=(
    "Installing NoMAD...,nomad"
    "Installing Chrome...,chrome"
    "Installing Umbrella...,umbrella"
    "Installing Microsoft Office...,office365"
    "Installing Adobe Design Suite...,adobeapps"
    "Updating Inventory...,dep_update_inventory"
  )

# Text that will display in the progress bar
  INSTALL_COMPLETE_TEXT="Setup Complete!"

# Text that will display inside the alert once policies have finished
  COMPLETE_ALERT_TEXT="Your Mac is now finished with initial setup and configuration. Press Quit to get started!"

########################################################################
# Main Script
########################################################################

# Caffeinating

echo "Time to caffeniate..."
caffeinate -d -i -m -s -u &

# Configure DEPNotify starting window
# Setting custom image if specified
  if [ "$BANNER_IMAGE_PATH" != "" ]; then
    echo "Command: Image: $BANNER_IMAGE_PATH" >> "$DEP_NOTIFY_CONFIG"
  fi

# Setting custom title if specified
  if [ "$BANNER_TITLE" != "" ]; then
    echo "Command: MainTitle: $BANNER_TITLE" >> "$DEP_NOTIFY_CONFIG"
  fi

# Setting custom main text if specified
  if [ "$MAIN_TEXT" != "" ]; then
    echo "Command: MainText: $MAIN_TEXT" >> "$DEP_NOTIFY_CONFIG"
  fi

# Validating true/false flags
  if [ "$TESTING_MODE" != true ] && [ "$TESTING_MODE" != false ]; then
    echo "$(date "+%a %h %d %H:%M:%S"): Testing configuration not set properly. Currently set to '$TESTING_MODE'. Please update to true or false." >> "$TMP_DEBUG_LOG"
    exit 1
  fi

# Checking policy array and adding the count from the additional options above.
ARRAY_LENGTH="$((${#POLICY_ARRAY[@]}+ADDITIONAL_OPTIONS_COUNTER))"
echo "Command: Determinate: $ARRAY_LENGTH" >> "$DEP_NOTIFY_CONFIG"

# Loop to run policies
for POLICY in "${POLICY_ARRAY[@]}"; do
    echo "Status: $(echo "$POLICY" | cut -d ',' -f1)" >> "$DEP_NOTIFY_CONFIG"
    if [ "$TESTING_MODE" = true ]; then
      sleep 10
    elif [ "$TESTING_MODE" = false ]; then
      "$JAMF_BINARY" policy -event "$(echo "$POLICY" | cut -d ',' -f2)"
    fi
done

# Exit gracefully after things are finished
echo "Status: $INSTALL_COMPLETE_TEXT" >> "$DEP_NOTIFY_CONFIG"
echo "Command: Quit: $COMPLETE_ALERT_TEXT" >> "$DEP_NOTIFY_CONFIG"
exit 0
