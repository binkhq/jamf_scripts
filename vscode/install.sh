#!/bin/zsh

install_vscode() {
    echo "$(date -u) - Installing Visual Studio Code"
    curl -sS -L "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal" -o /tmp/vscode.zip
    unzip -o /tmp/vscode.zip -d /tmp >/dev/null
    ps aux | grep "Visual Studio Code.app" | grep -v grep | awk '{print $2}' | xargs kill -9
    if [ -d "/Applications/Visual Studio Code.app" ]
    then
        rm -rf "/Applications/Visual Studio Code.app"
    fi
    mv "/tmp/Visual Studio Code.app" "/Applications"
    rm "/tmp/vscode.zip"
    chown "$(ls -l /dev/console | awk '{ print $3 }'):staff" "/Applications/Visual Studio Code.app"
}

install_vscode
