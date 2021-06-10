#!/bin/bash

fix_onedrive() {
	if [ -d "/Applications/OneDrive.localized/OneDrive.app" ]
	then
		echo "$(date -u) - Found Incorrectly configured OneDrive, cleaning up"
		pgrep "OneDrive" | xargs kill -9
		rm -rf /Applications/OneDrive.app
		rm -rf /Applications/OneDrive.localized/OneDrive.app
	else
		echo "$(date -u) - OneDrive is configured correctly, doing nothing"
	fi
}

fix_onedrive
