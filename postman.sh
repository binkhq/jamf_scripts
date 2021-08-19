#!/bin/zsh

set -e

uninstall() {
    if [ -d "/Applications/Postman.app" ]
    then
        echo "$(date -u) - Uninstalling Postman"
        killall -KILL "Postman" 2>/dev/null | true
        rm -rf /Applications/Postman.app
    else
        echo "$(date -u) - Postman already uninstalled, skipping uninstall"
    fi
}

install() {
    uninstall
    echo "$(date -u) - Installing Postman"
    curl -sS -L https://dl.pstmn.io/download/latest/osx -o /tmp/postman.zip
    unzip -o /tmp/postman.zip -d /tmp >/dev/null
    mv /tmp/Postman.app /Applications
    rm /tmp/postman.zip
}

if [[ $4 == "install" ]]; then
    install
elif [[ $4 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
