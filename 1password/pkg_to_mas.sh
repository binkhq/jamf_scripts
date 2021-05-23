#!/bin/bash

uninstall_1password()
{
    echo "$(date -u) - Uninstalling 1Password 7"
    pgrep "1Password 7" | xargs kill -9
    if [ -f "/Applications/1Password 7.app.zip" ]
    then
        echo "$(date -u) - Found leftover zip file from patching, deleting"
        rm -f "/Applications/1Password 7.app.zip"
    fi
    if [ -d "/Applications/1Password 7.app" ]
    then
        echo "$(date -u) - Deleted '1Password 7.app'"
        rm -rf "/Applications/1Password 7.app"
    fi
}

uninstall_1password
