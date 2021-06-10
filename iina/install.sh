#!/bin/zsh

install_iina() {
    echo "$(date -u) - Installing IINA"
    if [ -d "/Volumes/IINA" ]
    then
        hdiutil eject /Volumes/IINA >/dev/null
    fi
    curl -sS -L "$(curl -s https://api.github.com/repos/iina/iina/releases/latest | grep browser_download_url | cut -d'"' -f 4)" -o /tmp/iina.dmg
    hdiutil attach /tmp/iina.dmg >/dev/null
    pgrep "IINA" | xargs kill -9
    if [ -d "/Applications/IINA.app" ]
    then
        rm -rf /Applications/IINA.app
    fi
    cp -R /Volumes/IINA/IINA.app /Applications
    hdiutil eject /Volumes/IINA >/dev/null
    rm /tmp/iina.dmg
}

install_iina
