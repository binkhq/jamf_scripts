# OneDrive

## `localized.sh`

During our migration from PKG to MAS for OneDrive we noticed some of our Macs ended up with two copies of OneDrive installed, inventory would look similar to the below:

```
NAME            VERSION     PATH                                            APP STORE
OneDrive.app    21.083.0425 /Applications/OneDrive.app                      No
OneDrive.app	20.084.0426 /Applications/OneDrive.localized/OneDrive.app	Yes
```

The script was written to mitigate this by deleting both Applications, Jamf Policy then forces an inventory update which _should_ reschedule OneDrive reinstallation via MAS.

On a Mac which only has `/Applications/OneDrive.app` and not the `.localized` version, uninstallation is skipped.
