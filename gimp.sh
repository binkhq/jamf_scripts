#!/bin/zsh

uninstall() {
    if [[ -n $(find /Applications -type d -iname "*gimp*" -maxdepth 1 -print0 | grep .) ]]; then 
        echo "$(date -u) - Uninstalling GIMP"
        killall -KILL "gimp" 2>/dev/null | true
        find /Applications -type d -iname "*gimp*" -maxdepth 1 -print0 | xargs -0 rm -rf "{}"
    else
        echo "$(date -u) - GIMP is not installed"
    fi
}

if [[ $4 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
