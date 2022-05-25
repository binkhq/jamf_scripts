#!/bin/zsh

set -e

uninstall() {
    if [ -d "/Applications/Numbers.app" ]
    then
        echo "$(date -u) - Uninstalling Numbers"
        killall -KILL "Numbers" 2>/dev/null | true
        rm -rf /Applications/Numbers.app
    else
        echo "$(date -u) - Numbers already uninstalled, skipping uninstall"
    fi
}

if [[ $1 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
