#!/bin/zsh

set -e

uninstall() {
    if [ -d "/Applications/Charles.app" ]; then
        echo "$(date -u) - Uninstalling Charles"
        killall -KILL "Charles" 2>/dev/null | true
        rm -rf "/Applications/Charles.app"
    else
        echo "$(date -u) - Charles is already uninstalled, skipping uninstall"
    fi
}

install() {
    uninstall
    echo "$(date -u) - Installing Charles"
    ver="$(curl -sS https://www.charlesproxy.com/latest-release/download.do | grep -E -o '(v[0-9]\.[0-9]\.[0-9])' | cut -d 'v' -f2)"
    curl -sS "https://www.charlesproxy.com/assets/release/$ver/charles-proxy-$ver.dmg" -o "/tmp/charlesproxy.dmg"
    echo "Y" | hdiutil attach "/tmp/charlesproxy.dmg" >/dev/null
    cp -R "/Volumes/Charles Proxy v$ver/Charles.app" "/Applications"
    hdiutil eject "/Volumes/Charles Proxy v$ver/" >/dev/null
    rm "/tmp/charlesproxy.dmg"
}

if [[ $4 == "install" ]]; then
    install
elif [[ $4 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
