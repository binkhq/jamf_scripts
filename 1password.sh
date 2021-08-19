#!/bin/bash

set -e

uninstall() {
    if [ -f "/Applications/1Password 7.app.zip" ]
    then
        echo "$(date -u) - Cleaning up leftover 1Password patch files"
        rm -f "/Applications/1Password 7.app.zip"
    fi
    if [[ -n $(find /Applications -type d -iname "*1Password*" -maxdepth 1 -print0 | grep .) ]]; then 
        echo "$(date -u) - Uninstalling 1Password 7"
        killall -KILL "1Password 7" 2>/dev/null | true
        find /Applications -type d -iname "*1Password*" -maxdepth 1 -print0 | xargs -0 rm -rf "{}"
    else
        echo "$(date -u) - 1Password is not installed"
    fi
}

install() {
    uninstall
    echo "$(date -u) - Installing 1Password 7"
    curl -sS -L "https://app-updates.agilebits.com/download/OPM7" -o /tmp/1password.pkg
    installer -pkg /tmp/1password.pkg -target /
    rm /tmp/1password.pkg
}

if [[ $4 == "install" ]]; then
    install
elif [[ $4 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
