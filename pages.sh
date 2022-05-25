#!/bin/zsh

set -e

uninstall() {
    if [ -d "/Applications/Pages.app" ]
    then
        echo "$(date -u) - Uninstalling Pages"
        killall -KILL "Pages" 2>/dev/null | true
        rm -rf /Applications/Pages.app
    else
        echo "$(date -u) - Pages already uninstalled, skipping uninstall"
    fi
}

if [[ $1 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
