#!/bin/zsh

set -e

uninstall() {
    if [ -d "/Applications/GitKraken.app" ]; then
        echo "$(date -u) - Uninstalling GitKraken"
        killall -KILL "GitKraken" 2>/dev/null | true
        rm -rf "/Applications/GitKraken.app"
    else
        echo "$(date -u) - GitKraken is already uninstalled, skipping uninstall"
    fi
}

install() {
    uninstall
    echo "$(date -u) - Installing GitKraken"
    curl -sS -L "https://release.gitkraken.com/darwin/installGitKraken.dmg" -o "/tmp/gitkraken.dmg"
    hdiutil attach "/tmp/gitkraken.dmg" >/dev/null
    cp -R "/Volumes/Install GitKraken/GitKraken.app" "/Applications"
    hdiutil eject "/Volumes/Install GitKraken" >/dev/null
    rm "/tmp/gitkraken.dmg"
}

if [[ $4 == "install" ]]; then
    install
elif [[ $4 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
