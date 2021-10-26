#!/bin/bash

set -e

validate_checksum() {
    echo "$(date -u) - Validating Checksum"
    checksum=$(/sbin/md5 -q /tmp/InstallAssistant.pkg)
    if [ "$checksum" = "ADIgFD0AFPiPsu3M4Dbxow==" ]; then
        echo "$(date -u) - Checksum Successfully Validated, Installing"
        install_installer
    else
        echo "$(date -u) - Checksum not validated, Redownloading"
        download_installer
    fi
}

download_installer() {
    echo "$(date -u) - Beginning Download"
    curl -sS "https://binkpublic.blob.core.windows.net/public/macos/InstallAssistant-12.0.1.pkg" -o /tmp/InstallAssistant.pkg --retry 10 --retry-max-time 0
    echo "$(date -u) - Download Complete"
    install_installer
}

install_installer() {
    echo "$(date -u) - Beginning Installation"
    /usr/sbin/installer -pkg /tmp/InstallAssistant.pkg -target / &>/dev/null
    echo "$(date -u) - Installation Complete"
    cleanup
}

cleanup() {
    echo "$(date -u) - Cleaning up"
    rm /tmp/InstallAssistant.pkg
}

if [ ! -d "/Applications/Install macOS Monterey.app" ]; then
    if [ ! -f "/tmp/InstallAssistant.pkg" ]; then
        download_installer
    else
        echo "$(date -u) - Installer already downloaded"
        validate_checksum
    fi
else
    echo "$(date -u) - macOS Installer already installed, nothing to do"
fi
