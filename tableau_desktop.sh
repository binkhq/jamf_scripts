#!/bin/bash

uninstall() {
    if ls /Applications/Tableau\ Desktop*.app 1> /dev/null 2>&1;
    then
        echo "$(date -u) - Uninstalling Tableau Desktop"
        killall -KILL "Tableau" 2>/dev/null | true
        rm -rf /Applications/Tableau\ Desktop*.app
    else
        echo "$(date -u) - Tableau Desktop already uninstalled, skipping uninstall"
    fi
}

install() {
    uninstall
    echo "$(date -u) - Installing Tableau Desktop"
    curl -sS -L "https://downloads.tableau.com/esdalt/2022.2.0/TableauDesktop-2022-2-0.dmg" -o "/tmp/tableau.dmg"
    hdiutil attach "/tmp/tableau.dmg" >/dev/null
    installer -pkg /Volumes/Tableau\ Desktop/Tableau\ Desktop.pkg -target /
    hdiutil eject /Volumes/Tableau* >/dev/null
    rm "/tmp/tableau.dmg"
}

if [[ $4 == "install" ]]; then
    install
elif [[ $4 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
