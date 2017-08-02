#!/bin/sh

# -----------------------------------------------------------
# Post install script that runs at the end of the DeployStudio
# 
# File:			Post_Install.sh
# Usage:		./Post_Install.sh
# Author:		Gavin Willett
# Last Updated:	02/08/2017
# 
# Script hosted at https://github.com/jolegape/DeployStudio-Scripts
# -----------------------------------------------------------

# Get local hostname - should have been set as part of the DeployStudio task sequence
LOCALHOSTNAME=$(scutil --get LocalHostName)

# Disable startup Chime
nvram SystemAudioVolume=%80

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Restart automatically if the computer freezes
systemsetup -setrestartfreeze on

# Automatically illuminate built-in MacBook keyboard in low light
defaults write com.apple.BezelServices kDim -bool true

# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

# Set the munki config
defaults write /Library/Preferences/ManagedInstalls SoftwareRepoURL "http://SMCXS001.cairns.catholic.edu.au/MunkiRepo/"
defaults write /Library/Preferences/ManagedInstalls ClientIdentifier "$LOCALHOSTNAME"
defaults write /Library/Preferences/ManagedInstalls InstallAppleSoftwareUpdates -bool true

# Run munki on first startup, per https://groups.google.com/d/msg/munki-dev/e_bu7xGtL0M/_OFfC0lGEEsJ
touch /Users/Shared/.com.googlecode.munki.checkandinstallatstartup

#Enable VNC
defaults write /Library/Preferences/com.apple.RemoteManagement VNCAlwaysStartOnConsole -bool true
defaults write /Library/Preferences/com.apple.RemoteManagement AdminConsoleAllowsRemoteControl -bool false
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvncpw -vncpw 'Pa55w0rd'
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

#Enable Proxy AutoDiscovery
networksetup -setproxyautodiscovery "Ethernet" on
networksetup -setproxyautodiscovery "Wi-Fi" on

exit 0
