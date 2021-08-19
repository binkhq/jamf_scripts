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
    if [ -d "/Applications/Atom.app" ]; then
        echo "$(date -u) - Uninstalling Atom"
        killall -KILL "Atom" 2>/dev/null | true
        rm -rf "/Applications/Atom.app"
    else
        echo "$(date -u) - Atom is not installed"
    fi
}

install() {
    fetch_jq
    uninstall
    echo "$(date -u) - Installing Atom"
    curl -sS -L $(curl -s https://api.github.com/repos/atom/atom/releases/latest | /tmp/jq -r '.assets[] | select(.name == "atom-mac.zip") | .browser_download_url') -o /tmp/atom.zip
    # curl -sS -L $(curl -s https://api.github.com/repos/atom/atom/releases/latest | grep browser_download_url | grep mac | grep -v symbols | cut -d'"' -f 4) -o /tmp/atom.zip
    unzip -o /tmp/atom.zip -d /tmp >/dev/null
    mv /tmp/Atom.app /Applications
    rm /tmp/atom.zip
}

if [[ $4 == "install" ]]; then
    install
elif [[ $4 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
