#!/bin/zsh

uninstall() {
    if [ -d "/Applications/Visual Studio Code.app" ]; then
        echo "$(date -u) - Uninstalling Visual Studio Code"
        ps aux | grep "[V]isual Studio Code.app" | awk '{print $2}' | xargs kill -9
        rm -rf "/Applications/Visual Studio Code.app"
    else
        echo "$(date -u) - Visual Studio Code is not installed"
    fi
}

install() {
    uninstall
    echo "$(date -u) - Installing Visual Studio Code"
    curl -sS -L "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal" -o /tmp/vscode.zip
    unzip -o /tmp/vscode.zip -d /tmp >/dev/null
    mv "/tmp/Visual Studio Code.app" "/Applications"
    rm "/tmp/vscode.zip"
    chown "$(ls -l /dev/console | awk '{ print $3 }'):staff" "/Applications/Visual Studio Code.app"
}

if [[ $4 == "install" ]]; then
    install
elif [[ $4 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
