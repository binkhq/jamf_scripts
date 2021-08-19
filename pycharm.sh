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
    killall -KILL "pycharm" 2>/dev/null | true
    if [ -d "/Applications/PyCharm.app" ]; then
        rm -rf "/Applications/PyCharm.app"
    fi
}

install() {
    fetch_jq
    uninstall
    if [[ -n $(/usr/bin/arch | grep arm64) ]]; then
        arch="arm64"
        link=$(curl -sS "https://data.services.jetbrains.com/products?code=PCP&release.type=release" | jq -r ".[0].releases[0].downloads.macM1.link")
    else
        arch="intel"
        link=$(curl -sS "https://data.services.jetbrains.com/products?code=PCP&release.type=release" | jq -r ".[0].releases[0].downloads.mac.link")
    fi
    echo "$(date -u) - Installing PyCharm for $arch"
    curl -sS -L "$link" -o /tmp/pycharm.dmg
    hdiutil attach /tmp/pycharm.dmg >/dev/null
    cp -R /Volumes/PyCharm/PyCharm.app /Applications
    hdiutil eject /Volumes/PyCharm >/dev/null
    rm /tmp/pycharm.dmg
}

install_pycharm
