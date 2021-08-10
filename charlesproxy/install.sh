#!/bin/zsh

install_charlesproxy() {
    apiversion="$(curl -sS https://www.charlesproxy.com/latest-release/download.do\# | grep -E '(v[0-9]\.[0-9]\.[0-9])' |  cut -d '>' -f2 | cut -d '<' -f1 | cut -d 'v' -f2)"
    curl https://www.charlesproxy.com/assets/release/$apiversion/charles-proxy-$apiversion.dmg -o /tmp/charlesproxy.dmg
    yes Y | hdiutil attach /tmp/charlesproxy.dmg >/dev/null
    if [ -d "/Applications/Charles.app" ]; then
        rm -rf "/Applications/Charles.app"
    fi
    cp -R /Volumes/Charles\ Proxy\ v$apiversion/Charles.app /Applications/Charles.app
    hdiutil eject /Volumes/charlesproxy.dmg >/dev/null
    rm /tmp/charlesproxy.dmg
}

install_charlesproxy
