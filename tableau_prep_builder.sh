#!/bin/bash

uninstall() {
    if ls /Applications/Tableau\ Prep*.app 1> /dev/null 2>&1;
    then
        echo "$(date -u) - Uninstalling Tableau Prep Builder"
        killall -KILL "Tableau" 2>/dev/null | true
        rm -rf /Applications/Tableau\ Prep*.app
    else
        echo "$(date -u) - Tableau Prep Builder already uninstalled, skipping uninstall"
    fi
}

install() {
    uninstall
    echo "$(date -u) - Installing Tableau Prep Builder"
    curl -sS -L "https://downloads.tableau.com/esdalt/tableau_prep/2022.2.1/TableauPrep-2022-2-1.dmg" -o "/tmp/tableau.dmg"
    hdiutil attach "/tmp/tableau.dmg" >/dev/null
    installer -pkg /Volumes/Tableau\ Prep\ Builder/Tableau\ Prep\ Builder.pkg.pkg -target /
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
