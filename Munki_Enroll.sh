#!/bin/sh

# -----------------------------------------------------------
# Enrolls the computer into Munki during the deployment sequence
#
# 
# 
# 
# File:			Munki_Enroll.sh
# Usage:		./Munki_Enroll.sh
# Author:		Gavin Willett
# Last Updated:	02/08/2017
# 
# Script hosted at https://github.com/jolegape/DeployStudio-Scripts
# -----------------------------------------------------------

# Get local hostname - should have been set as part of the DeployStudio task sequence
LOCALHOSTNAME=$(scutil --get LocalHostName)

# Enrollment URL to be used with curl
ENROLMENTURL="http://SMCXS001.example.school.edu.au/MunkiRepo/munki-enroll/enroll.php"

# Read com.apple.RemoteDesktop Text1 field to get the correct identifier for munki
RDTEXT1=$(defaults read /Library/Preferences/com.apple.RemoteDesktop Text1)

if [ "$RDTEXT1" = "MUSIC" ]; then
	IDENTIFIER="_Music"
elif [ "$RDTEXT1" = "Art" ]; then
	IDENTIFIER="_Art"
elif [ "$RDTEXT1" = "Testing" ]; then
	IDENTIFIER="_Testing"
fi

# Echo the  output to the DeployStudio log
echo "Computer is assigned to the $RDTEXT1 department, with the identifier $IDENTIFIER"

# Enroll system with munki
/usr/bin/curl --max-time=5 --silent --get -d hostname="LOCALHOSTNAME" -d identifier1="$IDENTIFIER" "$ENROLMENTURL"

exit 0