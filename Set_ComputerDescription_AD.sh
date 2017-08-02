#!/bin/sh

# -----------------------------------------------------------
# Populates the computer description field in AD only
# with the Model, Serial Number and imaged date.
# 
# 
# 
# File:			Set_ComputerDescription_AD.sh
# Usage:		./Set_ComputerDescription_AD.sh
# Author:		Gavin Willett
# Last Updated:	02/08/2017
# 
# Script hosted at https://github.com/jolegape/DeployStudio-Scripts
# -----------------------------------------------------------

# Get local hostname - should have been set as part of the DeployStudio task sequence
LOCALHOSTNAME=$(scutil --get LocalHostName)

# Get Model of the system
MODEL=$(sysctl -n hw.model)

# Get Serial Number
SERIAL=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')

# Get current date
CURR_DATE=$(date +'%d/%m/%Y')

# Create description string in the following format of Manufacturer Model (SN) | Imaged on: dd/mm/yyyy
# eg Apple Inc, MacBookPro8,2 (Cxxxxxxxxxxx) | Imaged on: 02/08/2017
DESCRIPTION="Apple Inc. $MODEL ($SERIAL) | Imaged on: $CURR_DATE"

# Credentials with privileges to modify AD computer description
USERNAME=yourusername
PASSWORD=yourpassword

# Domain netbios name. Usually the part before .local, .com, etc
NETBIOS=YOURDOMAIN

CHECK_EXISTING_COMMENT=$(dscl -u $USERNAME -P $PASSWORD /Active\ Directory/$NETBIOS/All\ Domains -read /Computers/$LOCALHOSTNAME$ Comment)

if [ "$EXISTING_COMMENT" = "" ]; then
	# If no existing comment then populate the field
	dscl -u $USERNAME -P $PASSWORD /Active\ Directory/$NETBIOS/All\ Domains -append /Computers/$LOCALHOSTNAME$ Comment "$DESCRIPTION"
else
	# If existing comment is found, delete this first, then repopulate
	dscl -u $USERNAME -P $PASSWORD /Active\ Directory/$NETBIOS/All\ Domains -delete /Computers/$LOCALHOSTNAME$ Comment
	dscl -u $USERNAME -P $PASSWORD /Active\ Directory/$NETBIOS/All\ Domains -append /Computers/$LOCALHOSTNAME$ Comment "$DESCRIPTION"
fi

exit 0