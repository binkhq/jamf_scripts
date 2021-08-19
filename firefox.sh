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
    if [[ -n $(find /Applications -type d -iname "*firefox*" -maxdepth 1 -print0 | grep .) ]]; then 
        echo "$(date -u) - Uninstalling Firefox"
        killall -KILL "firefox" 2>/dev/null | true
        find /Applications -type d -iname "*firefox*" -maxdepth 1 -print0 | xargs -0 rm -rf "{}"
    else
        echo "$(date -u) - Firefox already uninstalled, skipping uninstall"
    fi
}

install() {
    fetch_jq
    uninstall
    version=$(curl -sS "https://product-details.mozilla.org/1.0/firefox.json" | /tmp/jq -r 'last(.releases[] | select(.category == "stability") | .version)')
    echo "$(date -u) - Installing Firefox $version"
    curl -sS "https://ftp.mozilla.org/pub/firefox/releases/$version/mac/en-GB/Firefox%20$version.pkg" -o /tmp/firefox.pkg
    installer -pkg /tmp/firefox.pkg -target / &>/dev/null 
    rm /tmp/firefox.pkg
}

if [[ $4 == "install" ]]; then
    install
elif [[ $4 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
