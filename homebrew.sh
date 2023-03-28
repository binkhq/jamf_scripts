#!/bin/zsh
# Inspired by https://github.com/Honestpuck/homebrew.sh/blob/master/homebrew-3.3.sh

CONSOLE_USER=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')
ARCHITECTURE=$(uname -m)

if [[ $ARCHITECTURE == "arm64" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
else
    HOMEBREW_PREFIX="/usr/local"
fi

function log() {
    echo -e "$(date -u) - $1"
}

function install_xcode_clt() {
    local CLT_PATH=$(xcode-select --print-path 2>/dev/null)
    local CLT_BUNDLED="/Applications/Xcode.app/Contents/Developer"
    local CLT_STANDALONE="/Library/Developer/CommandLineTools"
    
    if [[ $CLT_PATH =~ ^($CLT_BUNDLED|$CLT_STANDALONE)$ ]]; then
        log "Found Xcode Command Line Tools installed at: $CLT_PATH"
    else
        log "Xcode Command Line Tools not installed"
        log "Installing Xcode Command Line Tools: Standalone"
        local TMP_FILE="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
        touch "$TMP_FILE";
        local PKG=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
        softwareupdate --install "$PKG" --verbose;
        rm -f "$TMP_FILE"
    fi
}

function add_user_to_developer_group() {
    local GROUP_CHECK=$(groups "$CONSOLE_USER" | grep -c "_developer")
    if [[ $GROUP_CHECK != 1 ]]; then
        log "Adding user: $CONSOLE_USER to '_developer' group"
        /usr/sbin/dseditgroup -o edit -a "$CONSOLE_USER" -t user _developer
    fi
}

function setup_directories () {
    local HOMEBREW_DIRS=(
        "${HOMEBREW_PREFIX}/Homebrew"    
        "${HOMEBREW_PREFIX}/Cellar"
        "${HOMEBREW_PREFIX}/Caskroom"
        "${HOMEBREW_PREFIX}/Frameworks"
        "${HOMEBREW_PREFIX}/bin"
        "${HOMEBREW_PREFIX}/include"
        "${HOMEBREW_PREFIX}/lib"
        "${HOMEBREW_PREFIX}/opt"
        "${HOMEBREW_PREFIX}/etc"
        "${HOMEBREW_PREFIX}/sbin"
        "${HOMEBREW_PREFIX}/share/zsh/site-functions"
        "${HOMEBREW_PREFIX}/share/doc"
        "${HOMEBREW_PREFIX}/share"
        "${HOMEBREW_PREFIX}/var"
        "${HOMEBREW_PREFIX}/man"
        "${HOMEBREW_PREFIX}/man/man1"
        "${HOMEBREW_PREFIX}/share/man/man1"
        "/Library/Caches/Homebrew"
    )

    local ZSH_DIRS=(
        "${HOMEBREW_PREFIX}/share/zsh"
        "${HOMEBREW_PREFIX}/share/zsh/site-functions"
    )

    for DIR in "${HOMEBREW_DIRS[@]}"; do
        log "Setting up: $DIR"
        mkdir -p "$DIR"
        chown -R "$CONSOLE_USER:_developer" "$DIR";
    done

    for DIR in "${ZSH_DIRS[@]}"; do
        log "Setting up: $DIR"
        chmod 755 "$DIR";
    done

    chmod -R g+rwx "${HOMEBREW_PREFIX}/*" "/Library/Caches/Homebrew"
}

function install_homebrew() {
    if [[ -e "${HOMEBREW_PREFIX}/bin/brew" ]]; then
        log "Homebrew already installed"
        log "Updating Homebrew"
        su -l "${CONSOLE_USER}" -c "${HOMEBREW_PREFIX}/bin/brew update"
    else
        log "Installing Homebrew"
        curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "${HOMEBREW_PREFIX}/Homebrew"
        setup_directories
        ln -s "${HOMEBREW_PREFIX}/Homebrew/bin/brew" "${HOMEBREW_PREFIX}/bin/brew"

        log "Updating Homebrew"
        su -l "${CONSOLE_USER}" -c "${HOMEBREW_PREFIX}/bin/brew update"

        log "Setting up PATH"
        local BREW_PATHS=(
            "${HOMEBREW_PREFIX}/bin"
            "${HOMEBREW_PREFIX}/opt/openssl@3/bin"
        )
        local PATH_FILE="/Users/${CONSOLE_USER}/.zshrc"
        touch "$PATH_FILE"
        for DIR in "${BREW_PATHS[@]}"; do
            grep -qxF "export PATH=${DIR}:\$PATH" "$PATH_FILE" || echo "export PATH=${DIR}:\$PATH" >> "$PATH_FILE"
        done
        chown "${CONSOLE_USER}:staff" "$PATH_FILE"
    fi
}

if [[ "$4" == "install" ]]; then
    install_xcode_clt
    add_user_to_developer_group
    setup_directories
    install_homebrew
else
    echo "Unrecognised command, exiting..."
fi
