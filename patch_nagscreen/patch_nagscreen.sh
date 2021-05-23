#!/bin/bash

LOGO="https://api.gb.bink.com/content/media/logos/bink_cards.png"
TITLE="macOS Update Required"
TIMEOUT=60

MESSAGE="You're currently running an out of date version of macOS,
please upgrade your Operating System by heading to:

 Menu > System Preferences > Software Update

You will be prompted again until the patching process is complete

Please contact the Bink Helpdesk for any questions on helpdesk@bink.com or via Teams"

download_logo()
{
    if [ ! -f "/tmp/$(basename $LOGO)" ]
    then
        echo "$(date -u) - Downloading Logo"
        curl $LOGO -sS -o "/tmp/$(basename $LOGO)"
    fi
}

display_nag()
{
    download_logo

    echo "$(date -u) - Displaying Nag"

    /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper \
	-windowType utility \
    -icon "/tmp/$(basename $LOGO)" \
    -title "$TITLE" \
    -description "$MESSAGE" \
    -timeout $TIMEOUT
}

display_nag
