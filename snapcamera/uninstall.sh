#!/bin/bash

uninstall_snapcamera()
{
    _user=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')

    if [ -f "/Library/LaunchDaemons/com.snap.SnapCameraRemover.plist" ]
    then
        echo "$(date -u) - Uninstalling Snap Camera Remover"
        rm -f "/Library/LaunchDaemons/com.snap.SnapCameraRemover.plist"
        launchctl remove com.snap.SnapCameraRemover
    fi

    if [ -d "/Library/CoreMediaIO/Plug-Ins/DAL/SnapCamera.plugin" ]
    then
        echo "$(date -u) - Uninstalling Camera Plug-In"
        rm -rf "/Library/CoreMediaIO/Plug-Ins/DAL/SnapCamera.plugin"
    fi

    if [ -d "/Applications/Snap Camera.app" ]
    then
        echo "$(date -u) - Uninstalling Snap Camera app"
        pgrep "Snap Camera" | xargs kill -9
        rm -rf "/Applications/Snap Camera.app"
    fi

    if [ -f "/Users/$_user/Library/LaunchAgents/com.snap.AssistantService.plist" ]
    then
        echo "$(date -u) - Removing Snap Assistant Service"
        rm -f "/Users/$_user/Library/LaunchAgents/com.snap.AssistantService.plist"
    fi

    if [ -d "/Users/$_user/Library/Preferences/Snap" ]
    then
        echo "$(date -u) - Removing Local User Preferences"
        rm -rf "/Users/$_user/Library/Preferences/Snap"
    fi

    if [ -d "/Users/$_user/Library/Caches/Snap" ]
    then
        echo "$(date -u) - Removing Local User Cache"
        rm -rf "/Users/$_user/Library/Caches/Snap"
    fi
}

uninstall_snapcamera
