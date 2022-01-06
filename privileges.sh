#!/bin/zsh

set -e

fetch_jq() {
    if [[ -n $(/usr/bin/arch | grep arm64) ]]; then
        arch="arm64"
        link="https://binkpublic.blob.core.windows.net/public/jq/1.6/arm64"
    else
        arch="intel"
        link="https://binkpublic.blob.core.windows.net/public/jq/1.6/amd64"
    fi
    if [ ! -f "/tmp/jq" ]; then
        echo "$(date -u) - Installing jq for $arch"
        curl -sS $link -o /tmp/jq
        chmod +x /tmp/jq
    fi
}

uninstall() {
    echo "$(date -u) - Uninstalling App"
    rm -rf /Applications/Privileges.app
    if [[ -f "/Library/LaunchDaemons/corp.sap.privileges.helper.plist" ]]; then
        echo "$(date -u) - Unloading LaunchDaemon"
        launchctl unload /Library/LaunchDaemons/corp.sap.privileges.helper.plist
    fi
    echo "$(date -u) - Cleaning up"
    rm -rf /Library/PrivilegedHelperTools
    rm -f /Library/LaunchDaemons/corp.sap.privileges.helper.plist
}

postinstall() {
    # Modified from: https://github.com/autopkg/rtrouton-recipes/blob/master/Privileges/Scripts/postinstall
    helperPath="/Applications/Privileges.app/Contents/XPCServices/PrivilegesXPC.xpc/Contents/Library/LaunchServices/corp.sap.privileges.helper"
    helperPlist="/Library/LaunchDaemons/corp.sap.privileges.helper.plist"

    if [[ ! -d "/Library/PrivilegedHelperTools" ]]; then
        echo "$(date -u) - Creating Essential Directories"
        /bin/mkdir -p "/Library/PrivilegedHelperTools"
        /bin/chmod 755 "/Library/PrivilegedHelperTools"
        /usr/sbin/chown -R root:wheel "/Library/PrivilegedHelperTools"
    fi

    echo "$(date -u) - Installing PrivilegedHelperTools"
    cp -f "$helperPath" "/Library/PrivilegedHelperTools"
    chmod 755 "/Library/PrivilegedHelperTools/corp.sap.privileges.helper"

    echo "$(date -u) - Installing LaunchDaemon"
    cat > "$helperPlist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD helperPlistPath 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>corp.sap.privileges.helper</string>
	<key>MachServices</key>
	<dict>
		<key>corp.sap.privileges.helper</key>
		<true/>
	</dict>
	<key>ProgramArguments</key>
	<array>
		<string>/Library/PrivilegedHelperTools/corp.sap.privileges.helper</string>
	</array>
</dict>
</plist>
EOF
    chmod 644 "$helperPlist"

    echo "$(date -u) - Starting LaunchDaemon"
    launchctl bootstrap system "$helperPlist"
}

install() {
    fetch_jq
    uninstall
    echo "$(date -u) - Installing Privileges"
    curl -sS -L $(curl -s https://api.github.com/repos/SAP/macOS-enterprise-privileges/releases/latest | /tmp/jq -r '.assets[] | select(.name == "Privileges.zip") | .browser_download_url') -o /tmp/Privileges.zip
    unzip -o /tmp/Privileges.zip -d /tmp >/dev/null
    mv /tmp/Privileges.app /Applications
    rm /tmp/Privileges.zip
    postinstall
}

install
