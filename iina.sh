#!/bin/zsh

set -e

fetch_jq() {
    if [[ -n $(/usr/bin/arch | grep arm64) ]]; then
        arch="arm64"
        link="https://binkpublic.blob.core.windows.net/public/jq/1.6/arm64"
    else
        arch="intel"
        link="https://binkpublic.blob.core.windows.net/public/jq/1.6/amd64"
    fi
    if [ ! -f "/tmp/jq" ]; then
        echo "$(date -u) - Installing jq for $arch"
        curl -sS $link -o /tmp/jq
        chmod +x /tmp/jq
    fi
}

uninstall() {
    if [ -d "/Applications/IINA.app" ]
    then
        echo "$(date -u) - Uninstalling IINA"
        killall -KILL "IINA" 2>/dev/null | true
        rm -rf /Applications/IINA.app
    else
        echo "$(date -u) - IINA already uninstalled, skipping uninstall"
    fi
}

install() {
    fetch_jq
    uninstall
    echo "$(date -u) - Installing IINA"
    if [ -d "/Volumes/IINA" ]
    then
        hdiutil eject /Volumes/IINA >/dev/null
    fi
    curl -sS -L "$(curl -sS https://api.github.com/repos/iina/iina/releases/latest | jq -r '.assets[0].browser_download_url')" -o /tmp/iina.dmg
    hdiutil attach /tmp/iina.dmg >/dev/null
    cp -R /Volumes/IINA/IINA.app /Applications
    hdiutil eject /Volumes/IINA >/dev/null
    rm /tmp/iina.dmg
}

if [[ $4 == "install" ]]; then
    install
elif [[ $4 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
