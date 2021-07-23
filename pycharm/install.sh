#!/bin/zsh

install_pycharm() {
    if [[ -n $(/usr/bin/arch | grep arm64) ]]; then
        arch="arm64"
        link=$(curl -sS "https://data.services.jetbrains.com/products?code=PCP&release.type=release" | python -c 'import json, sys; print(json.loads(sys.stdin.read())[0]["releases"][0]["downloads"]["macM1"]["link"])')
    else
        arch="intel"
        link=$(curl -sS "https://data.services.jetbrains.com/products?code=PCP&release.type=release" | python -c 'import json, sys; print(json.loads(sys.stdin.read())[0]["releases"][0]["downloads"]["mac"]["link"])')
    fi
    echo "$(date -u) - Installing PyCharm for $arch"
    curl -sS -L "$link" -o /tmp/pycharm.dmg
    hdiutil attach /tmp/pycharm.dmg >/dev/null
    pkill "pycharm"
    if [ -d "/Applications/PyCharm.app" ]; then
        rm -rf "/Applications/PyCharm.app"
    fi
    cp -R /Volumes/PyCharm/PyCharm.app /Applications
    hdiutil eject /Volumes/PyCharm >/dev/null
    rm /tmp/pycharm.dmg
}

install_pycharm
