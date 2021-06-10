#!/bin/bash

printer_admins() {
    if ! dscl . -read /Groups/lpadmin | grep ABCDEFAB-CDEF-ABCD-EFAB-CDEF0000000C >/dev/null
    then
        echo "$(date -u) - Adding 'everybody' group to 'lpadmin' group"
        /usr/sbin/dseditgroup -o edit -a everyone -t group lpadmin
    else
        echo "$(date -u) - Configuration already completed, nothing to do"
    fi
}

printer_admins
