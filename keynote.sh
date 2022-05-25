#!/bin/zsh

set -e

uninstall() {
    if [ -d "/Applications/Keynote.app" ]
    then
        echo "$(date -u) - Uninstalling Keynote"
        killall -KILL "Keynote" 2>/dev/null | true
        rm -rf /Applications/Keynote.app
    else
        echo "$(date -u) - Keynote already uninstalled, skipping uninstall"
    fi
}

if [[ $1 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
