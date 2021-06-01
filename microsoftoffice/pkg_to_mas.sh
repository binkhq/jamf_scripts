#!/bin/bash

office_upgrade() {
    for app in "Microsoft Excel" "Microsoft Word" "Microsoft PowerPoint" "Microsoft OneNote" "Microsoft Outlook"; do
        app_path="/Applications/$app.app"
        install_backup_path="$app_path.installBackup"
        echo "$(date) - Processing: $app"
        if [ -d "$app_path" ]; then
            if mdls "$app_path" | grep kMDItemAppStoreHasReceipt >/dev/null; then
                echo "$(date -u) -     is already a MAS app, skipping"
            else
                echo "$(date -u) -     is not a MAS app"
                if pgrep "$app" >/dev/null; then
                    echo "$(date -u) -     is running, unable to proceed with removal"
                else
                    echo "$(date -u) -     uninstalling $app"
                    rm -rf "$app_path"
                fi
            fi
        fi
        if [ -d "$install_backup_path" ]; then
            echo "$(date -u) -     Removing $install_backup_path"
            rm -rf "$install_backup_path"
        fi
    done
}

office_upgrade
