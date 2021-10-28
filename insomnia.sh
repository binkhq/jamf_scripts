#!/bin/zsh

set -e

uninstall() {
    if [ -d "/Applications/Insomnia.app" ]
    then
        echo "$(date -u) - Uninstalling Insomnia"
        killall -KILL "Insomnia" 2>/dev/null | true
        rm -rf /Applications/Insomnia.app
    else
        echo "$(date -u) - Insomnia already uninstalled, skipping uninstall"
    fi
}

install() {
    uninstall
    echo "$(date -u) - Installing Insomnia"
    curl -sS -L "https://updates.insomnia.rest/downloads/mac/latest?app=com.insomnia.app" -o "/tmp/insomnia.dmg"
    hdiutil attach "/tmp/insomnia.dmg" >/dev/null
    cp -R '/Volumes/Insomnia'*'/Insomnia.app' "/Applications"
    hdiutil eject /Volumes/Insomnia* >/dev/null
    rm "/tmp/insomnia.dmg"
}

if [[ $4 == "install" ]]; then
    install
elif [[ $4 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
