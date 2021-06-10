#!/bin/zsh

install_postman() {
    echo "$(date -u) - Installing Postman"
    curl -sS -L https://dl.pstmn.io/download/latest/osx -o /tmp/postman.zip
    unzip -o /tmp/postman.zip -d /tmp >/dev/null
    pgrep "Postman" | xargs kill -9
    if [ -d "/Applications/Postman.app" ]
    then
        rm -rf /Applications/Postman.app
    fi
    mv /tmp/Postman.app /Applications
    rm /tmp/postman.zip
}

install_postman
