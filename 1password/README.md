# 1Password

## `pkg_to_mas.sh`

During our migration from PKG to MAS based deployments, we needed a quick script to uninstall 1Password from our Macs, immediately after this script runs the Jamf Policy should send inventory to Jamf Pro causing it to reinstall 1Password via MAS.
