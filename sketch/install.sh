#!/bin/zsh

install_sketch() {
    echo "$(date -u) - Installing Sketch"
    curl -sS -L "$(curl -sS https://www.sketch.com/updates/ | grep zip | head -n 1 | cut -d'"' -f 2)" -o /tmp/sketch.zip
    unzip -o /tmp/sketch.zip -d /tmp >/dev/null
    pgrep "Sketch" | xargs kill -9
    if [ -d "/Applications/Sketch.app" ]
    then
        rm -rf /Applications/Sketch.app
    fi
    mv /tmp/Sketch.app /Applications
    rm /tmp/sketch.zip
}

install_abstract() {
    echo "$(date -u) - Installing Abstract"
    curl -sS -L https://api.goabstract.com/releases/latest/download -o /tmp/abstract.zip
    unzip -o /tmp/abstract.zip -d /tmp >/dev/null
    pgrep "Abstract" | xargs kill -9
    if [ -d "/Applications/Abstract.app" ]
    then
        rm -rf /Applications/Abstract.app
    fi
    mv /tmp/Abstract.app /Applications
    rm /tmp/abstract.zip
}

install_craftmanager() {
    echo "$(date -u) - Installing CraftManager"
    curl -sS -L https://craft-assets.invisionapp.com/CraftManager/production/CraftManager.zip -o /tmp/craftmanager.zip
    unzip -o /tmp/craftmanager.zip -d /tmp >/dev/null
    pgrep "CraftManager" | xargs kill -9
    if [ -d "/Applications/CraftManager.app" ]
    then
        rm -rf /Applications/CraftManager.app
    fi
    mv /tmp/CraftManager.app /Applications
    rm /tmp/craftmanager.zip
}

install_sketch
install_abstract
install_craftmanager
