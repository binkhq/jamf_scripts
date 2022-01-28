#!/bin/zsh

set -e

download_url="https://d32a6ru7mhaq0c.cloudfront.net/Zscaler-osx-3.4.1.14-installer.app.zip"
download_md5="79693701424d42bf09261f63576d5b0d"
download_filename="/tmp/zscaler.zip"
zscaler_cloud="zscaler"
zscaler_domain="bink.com"
zscaler_ui="1"
zscaler_unattendedmodeui="none"

download() {
    echo "$(date -u) - Downloading Zscaler from '$download_url'"
    curl -sS -L "$download_url" -o "/tmp/zscaler.zip"
    if [[ $(md5 -q "$download_filename") = "$download_md5" ]]; then
        echo "$(date -u) - Checksum Validated, proceeding"
        unzip -o "$download_filename" -d '/tmp' >/dev/null
        install
        rm -f "$download_filename"
        exit 0
    else
        echo "$(date -u) - Checksum Validation Failed, aborting"
        rm -f "$download_filename"
        exit 1
    fi
}

install() {
    app_path="$(ls -d /tmp/Zscaler*.app)"
    bin_dir="$app_path/Contents/MacOS"
    if [[ $(arch) = "arm64" ]]; then
        echo "$(date -u) - Installing arm64 version"
        binary="$bin_dir/osx-arm64"
    else
        echo "$(date -u) - Installing x86 version"
        binary="$bin_dir/osx-x86_64"
    fi
    echo "$(date -u) - Beginning Installation"
    $binary --cloudName $zscaler_cloud --userDomain $zscaler_domain --hideAppUIOnLaunch $zscaler_ui --unattendedmodeui $zscaler_unattendedmodeui
    rm -rf "$app_path"
}

if [[ -d '/Applications/Zscaler/Zscaler.app' ]]; then
    echo "$(date -u) - Zscaler already installed, exiting"
    exit 0
else
    echo "$(date -u) - Zscaler not found, proceeding with download"
    download
fi
