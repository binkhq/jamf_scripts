#!/bin/zsh

# This script is desgined to be run from Jamf where the $4 script args can be set to
# one of either "install" or "uninstall" to facilitate installation/uninstallation
# alternatively, just remove the if/else block at the bottom and set it to one of
# "install" or "uninstall"

# Note: We provision our Macs with a `jamfadmin` user as part of the PreStage Enrollment
# If you use a different username, make sure to modify the install_user_launch_agent and
# install_user_launch_agent functions

# TODO: Make the above disclaimer a variable instead, pull requests welcome

# Much of this script was inspired by the work of https://github.com/rtrouton
# For example: https://github.com/autopkg/rtrouton-recipes/blob/master/Privileges/Scripts/postinstall

set -e

fetch_jq() {
    if /usr/bin/arch | grep -q arm64; then
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
    remove_user_launch_agent
}

postinstall() {
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

install_user_launch_agent() {
    users=$(dscl . list /Users | grep -v '_\|daemon\|jamfadmin\|nobody\|root')
    while IFS= read -r i
        do
            echo "$(date -u) - Installing LaunchAgent for user $i"
            if [[ ! -d "/Users/$i/Library/LaunchAgents" ]]; then
                echo "$(date -u) - Creating LaunchAgents directory for user $i"
                mkdir -p "/Users/$i/Library/LaunchAgents"
                chown "$i":"staff" "/Users/$i/Library/LaunchAgents"
            fi
            if [[ ! -f "/Users/$i/Library/LaunchAgents/corp.sap.privileges.plist" ]]; then
                echo "$(date -u) - Adding 'corp.sap.privileges.plist' to LaunchAgents for user $i"
                cat > "/Users/$i/Library/LaunchAgents/corp.sap.privileges.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>corp.sap.privileges</string>
	<key>ProgramArguments</key>
	<array>
		<string>/Applications/Privileges.app/Contents/Resources/PrivilegesCLI</string>
		<string>--remove</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>LimitLoadToSessionType</key>
	<string>Aqua</string>
</dict>
</plist>
EOF
                # Fix a weird edge case that only seemed to impact one of our users.
                chown_username=$(echo "$i" | tr '[:upper:]' '[:lower:]')
                chown "$chown_username":"staff" "/Users/$i/Library/LaunchAgents/corp.sap.privileges.plist"
            fi
    done <<< "$users"
}

remove_user_launch_agent() {
    users=$(dscl . list /Users | grep -v '_\|daemon\|jamfadmin\|nobody\|root')
    while IFS= read -r i
        do
            echo "$(date -u) - Removing LaunchAgent for user $i"
            rm -f "/Users/$i/Library/LaunchAgents/corp.sap.privileges.plist"
    done <<< "$users"
}

install() {
    fetch_jq
    uninstall
    echo "$(date -u) - Installing Privileges"
    curl -sS -L "$(curl -s https://api.github.com/repos/SAP/macOS-enterprise-privileges/releases/latest | /tmp/jq -r '.assets[] | select(.name == "Privileges.zip") | .browser_download_url')" -o /tmp/Privileges.zip
    unzip -o /tmp/Privileges.zip -d /tmp >/dev/null
    mv /tmp/Privileges.app /Applications
    rm /tmp/Privileges.zip
    postinstall
    install_user_launch_agent
    echo "$(date -u) - Installation Complete"
}

if [[ $4 == "install" ]]; then
    install
elif [[ $4 == "uninstall" ]]; then
    uninstall
else
    echo "Unrecognised command, exiting..."
fi
