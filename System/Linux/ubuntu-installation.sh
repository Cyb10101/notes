#!/usr/bin/env bash

# wget -O - https://raw.githubusercontent.com/Cyb10101/notes/master/System/Linux/ubuntu-installation.sh | bash

# Development:
# echo ~/Sync/notes/System/Linux/ubuntu-installation.sh | entr cp ~/Sync/notes/System/Linux/ubuntu-installation.sh ~/Downloads/public/

# Exit on error
set -e

# @todo if script is root: sudo $USER $HOME ~ is root path
#echo "1u: $USER"
# Elevate script permission
# Maybe: --preserve-env or -E for
# Indicates to the security policy that the user wishes to preserve their existing environment variables.
# The securitypolicy may return an error if the user does not have permission to preserve the environment.
#[ "${EUID}" -eq 0 ] || exec sudo "${0}" "$@"
    # exec sudo -E4 "$0" ${1+"$@"}
#echo "u: $USER";exit

# Useful for script
scriptPath="$(cd "$(dirname "${0}")" >/dev/null 2>&1; pwd -P)"

# Get current XDG (X Desktop Group) user directories
test -f ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs && source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
DIR_DESKTOP="${XDG_DESKTOP_DIR:-$HOME/Desktop}"

textColor() {
    echo -e "\033[0;3${1}m${2}\033[0m"
}

checkCurlInstalled() {
  if ! command -v yad &>/dev/null; then
    textColor 3 "# Install: Curl"
    sudo apt update
    sudo apt -y install curl
  fi
  if ! command -v curl &>/dev/null; then
    textColor 1 "Curl is not installed. Aborting!"
    exit 1;
  fi
}

checkYadInstalled() {
  if ! command -v yad &>/dev/null; then
    textColor 3 "# Install: Yad"
    sudo apt update
    sudo apt -y install yad
  fi
  if ! command -v yad &>/dev/null; then
    textColor 1 "Yad is not installed. Aborting!"
    exit 1;
  fi
}

getUsername() {
    #local selectedUsername=($(yad --center --on-top --width=600 --height=200 --title="Select current user" \
    #    --list --radiolist --separator=" " \
    #    --column=" " --column="Username" \
    #    --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
    #    "TRUE" "cyb10101" \
    #    "FALSE" "user" \
    #))
    #echo "${selectedUsername}"

    local text=${1:-Select a user}
    local selectedUsername=($(yad --center --on-top --width=400 --title="Select a username" \
        --entry --text="${text}:" --image="user-info" --editable  \
        --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
        "cyb10101" "user" \
    ))
    echo "${selectedUsername}"
}

# VERSION=$(getGithubReleaseLatest 'username/repository')
getGithubReleaseLatest() {
    local usernameRepository="${1}"
    local VERSION=$(curl -fsSL https://api.github.com/repos/${usernameRepository}/releases/latest \
      | jq -r '.tag_name' | sed -r 's/v//g');
    echo "${VERSION}"
}

# URL=$(getGithubReleaseLatestFileUrl 'username/repository' 'filename-\d+\.\d+\.\d+.*-x86_64.deb')
getGithubReleaseLatestFileUrl() {
    local usernameRepository="${1}"
    local URL=$(curl -fsSL https://api.github.com/repos/${usernameRepository}/releases/latest \
    | jq -r --arg filterFile "${2}" '.assets[] | select(.name | test("\($filterFile)")) | .browser_download_url');
    echo "${URL}"
}

# Script #######################################################################
reboot() {
    set +e
    yad --center --on-top --image="gtk-dialog-warning" --width=300 --title "Reboot" \
        --button="gtk-cancel:1" --button="gtk-ok:0" --text "Reboot System?"
    if [ $? -eq 0 ]; then sudo reboot; exit; fi
    set -e
}

prepareSystem() {
    # System
    if [ ! -d /etc/xdg/autostart ]; then
        sudo mkdir -p /etc/xdg/autostart
    fi
    if [ ! -d /usr/local/share/icons ]; then
        sudo mkdir -p /usr/local/share/icons
    fi

    # User
    if [ ! -d ~/opt ]; then
        mkdir -p ~/opt
    fi
    if [ ! -d ~/.config/autostart ]; then
        mkdir -p ~/.config/autostart
    fi
    if [ ! -d ~/.local/share/applications ]; then
        mkdir -p ~/.local/share/applications
    fi
}

configure() {
    textColor 3 'Configure'
    selectedList=($(yad --center --on-top --width=600 --height=400 --title="Configure" \
        --list --checklist --multiple --separator=" " \
        --column=" " --column="Action" --column="Application" --column="Description" \
        --search-column=3 --hide-column=2 --print-column=2 \
        "FALSE" "monitor15" "Monitor: 15" "Monitor off in 15 minutes" \
        "FALSE" "monitor0" "Monitor: 0" "Monitor always on" \
        "FALSE" "battery0" "Battery: nothing" "Sleep inactive battery type do nothing" \
        "FALSE" "grubBootMenu" "Grub: Boot menu" "Show boot menu" \
        "FALSE" "grubDisableQuiteSplash" "Grub: Disable Quit Splash" "Disable quite and splash screen" \
    ))

    updateGrub=0
    for selected in "${selectedList[@]}"; do
        if [ "${selected}" == "monitor15" ]; then
            echo 'Monitor off in 15 minutes'
            gsettings set org.gnome.desktop.session idle-delay 0
        elif [ "${selected}" == "monitor0" ]; then
            echo 'Monitor always on'
            gsettings set org.gnome.desktop.session idle-delay 900
        elif [ "${selected}" == "battery0" ]; then
            echo 'Sleep inactive battery type do nothing'
            gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
        elif [ "${selected}" == "grubBootMenu" ]; then
            echo 'Grub: Show boot menu'
            updateGrub=1
            sudo sed -i -r 's/^#?(GRUB_TIMEOUT_STYLE=hidden)$/#\1/g' /etc/default/grub
            sudo sed -i -r 's/^#?(GRUB_TIMEOUT)=[0-9]+$/\1=10/g' /etc/default/grub
        elif [ "${selected}" == "grubDisableQuiteSplash" ]; then
            echo 'Grub: Disable quite and splash screen'
            updateGrub=1
            sudo sed -i -r 's/^#?(GRUB_CMDLINE_LINUX_DEFAULT=".*)quiet(.*")$/\1\2/g' /etc/default/grub
            sudo sed -i -r 's/^#?(GRUB_CMDLINE_LINUX_DEFAULT=".*)splash(.*")$/\1\2/g' /etc/default/grub
            sudo sed -i -r 's/^#?(GRUB_CMDLINE_LINUX_DEFAULT=")[ ]+(")$/\1\2/g' /etc/default/grub
        fi
    done

    if [[ updateGrub -eq 1 ]]; then
        echo 'Grub: Update'
        sudo update-grub
    fi
}

systemUpdate() {
    textColor 3 'System update'
    existsSnap=$(command -v snap &>/dev/null && echo 'TRUE' || echo 'FALSE')
    existsFlatpak=$(command -v flatpak &>/dev/null && echo 'TRUE' || echo 'FALSE')
    selectedList=($(yad --center --on-top --width=600 --height=200 --title="System update" \
        --list --checklist --multiple --separator=" " \
        --column=" " --column="Action" --column="Application" --column="Description" \
        --search-column=3 --hide-column=2 --print-column=2 \
        "FALSE" "addAptSources" "Add apt sources" "Add apt sources: main, universe, restricted, multiverse" \
        "TRUE" "apt" "Update System" "apt full-upgrade" \
        "${existsSnap}" "snap" "Update Snap" "snap refresh" \
        "${existsFlatpak}" "flatpak" "Update Flatpak" "flatpak update and uninstall unused" \
    ))
    for selected in "${selectedList[@]}"; do
        if [ "${selected}" == "addAptSources" ]; then
            # Main:       Officially Supported, Open-Source
            # Restricted: Officially Supported, Closed-Source (Proprietary)
            # Universe:   Community-Maintained, Open-Source
            # Multiverse: Unsupported, Closed-Source and Patent-Encumbered
            sudo add-apt-repository -y main universe restricted multiverse
            #sudo apt update
        elif [ "${selected}" == "apt" ]; then
            echo 'Update System...'
            sudo apt update && sudo apt -y full-upgrade
        elif [ "${selected}" == "snap" ]; then
            echo 'Update Snap...'
            if command -v snap &>/dev/null; then
                sudo snap refresh
            fi
        elif [ "${selected}" == "flatpak" ]; then
            echo 'Update Flatpak...'
            if command -v flatpak &>/dev/null; then
                sudo flatpak update -y && sudo flatpak uninstall --unused
            fi
        fi
    done
}

# https://flatpak.org/
# https://flathub.org/
installFlatpak() {
    textColor 3 'Install: Flatpak'
    sudo apt -y install flatpak gnome-software-plugin-flatpak
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    # Restart system: reboot
}

installWine() {
    textColor 3 'Install: Wine'
    sudo dpkg --add-architecture i386
    sudo apt update
    sudo apt -y install wine-stable winbind wine32:i386 winetricks
    winecfg -v win11
}

# https://docker.com
installDocker() {
    textColor 3 'Install: Docker'
    sudo apt -y install docker.io

    # Only if your want run it for another user than root
    selectedUsername=$(getUsername 'Select a user to run Docker container')
    if [ -z "${selectedUsername}" ]; then
        textColor 1 "Error: Username not selected!"
        exit 1;
    fi
    sudo usermod -aG docker ${selectedUsername}
}

# https://docs.docker.com/compose/
installDockerCompose() {
    textColor 3 'Install: Docker Compose'
    local usernameRepository='docker/compose'
    local VERSION=$(getGithubReleaseLatest "${usernameRepository}")
    curl --progress-bar -o /tmp/docker-compose -fL "https://github.com/${usernameRepository}/releases/download/v${VERSION}/docker-compose-$(uname -s)-$(uname -m)"
    sudo install /tmp/docker-compose /usr/local/bin/docker-compose
}

# Software #####################################################################
# https://www.mozilla.org/firefox/
installFirefoxFlatpak() {
    textColor 3 'Install: Firefox (Flatpak)'
    sudo flatpak install -y flathub org.mozilla.firefox
}

installFirefoxSnap() {
    textColor 3 'Install: Firefox (Snap)'
    sudo snap install firefox
}

removeFirefoxSnap() {
    textColor 3 'Remove: Firefox (Snap)'
    if [ -d ~/snap/firefox/common/.mozilla ]; then
        echo 'Create a backup on desktop: Firefox'
        tar -C ~/snap/firefox/common/ -czf "${DIR_DESKTOP}/firefox_snap_$(date +%Y-%m-%d).tar.gz" .mozilla
    fi
    sudo apt-get -y remove firefox # Transition package
    sudo snap remove firefox
}

# Recommended
# https://support.mozilla.org/en-US/kb/install-firefox-linux#w_install-firefox-deb-package-for-debian-based-distributions
installFirefoxForceAptMozilla() {
    textColor 3 'Install: Firefox (Force Apt Mozilla)'

    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc 1>/dev/null
    fingerprint=$(gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); print $0}')
    if [ "${fingerprint}" != "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3" ]; then
        echo "Verification failed: The fingerprint (${fingerprint}) does not match\!"; exit 1
    fi
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list 1>/dev/null
    printf "Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1001" | sudo tee /etc/apt/preferences.d/mozilla 1>/dev/null

    sudo apt-get update
    sudo apt-get -y install firefox firefox-l10n-de
}

# https://launchpad.net/~mozillateam/+archive/ubuntu/ppa
installFirefoxForceAptPPA() {
    textColor 3 'Install: Firefox (Force Apt PPA)'
    sudo add-apt-repository -y ppa:mozillateam/ppa
    printf "Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001" | sudo tee /etc/apt/preferences.d/mozilla-firefox
    echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
    sudo apt -y install firefox
}

installChromiumSnap() {
    textColor 3 'Install: Chromium (Snap)'
    sudo snap install chromium chromium-ffmpeg
}

# https://www.thunderbird.net/
installThunderbird() {
    textColor 3 'Install: Thunderbird'
    sudo apt -y install thunderbird
}

installThunderbirdSnap() {
    textColor 3 'Install: Thunderbird (Snap)'
    sudo snap install thunderbird
}

# https://libreoffice.org
installLibreOffice() {
    textColor 3 'Install: LibreOffice'
    sudo add-apt-repository -y ppa:libreoffice/ppa
    sudo apt -y install libreoffice libreoffice-base libreoffice-l10n-de
}

installPdfArranger() {
    textColor 3 'Install: PDF Arranger'
    sudo apt -y install pdfarranger
}

# https://hyliu.me/fluent-reader/
installFluentReader() {
    textColor 3 'Install: Fluent Reader'
    local usernameRepository='yang991178/fluent-reader'
    local VERSION=$(getGithubReleaseLatest "${usernameRepository}")

    curl --progress-bar -o /tmp/fluent-reader.AppImage -fL "https://github.com/${usernameRepository}/releases/download/v${VERSION}/Fluent.Reader.${VERSION}.AppImage"
    sudo install /tmp/fluent-reader.AppImage /usr/local/bin/fluent-reader.AppImage

    sudo curl --progress-bar -o /usr/local/share/icons/fluent-reader.png -fL "https://raw.githubusercontent.com/${usernameRepository}/master/build/icon.png"

    cat << EOF | sudo tee /usr/share/applications/fluent-reader.desktop
[Desktop Entry]
Name=Fluent Reader
Comment=Modern desktop RSS reader built with Electron, React, and Fluent UI.
Exec="/usr/local/bin/fluent-reader.AppImage" %U
Terminal=false
Type=Application
Icon=/usr/local/share/icons/fluent-reader.png
StartupWMClass=fluent-reader
Categories=Utility;
TryExec=/usr/local/bin/fluent-reader.AppImage
EOF
}

installCalibre() {
    textColor 3 'Install: Calibre'
    sudo apt -y install calibre
}

# https://comix.sourceforge.net/
installComix() {
    textColor 3 'Install: Comix (mComix)'
    sudo apt -y install mcomix
}

# https://www.yacreader.com/
installYacReaderFlatpak() {
    textColor 3 'Install: YACReader (Flatpak)'
    sudo flatpak install -y flathub com.yacreader.YACReader
    #flatpak override --user com.yacreader.YACReader --filesystem=/mnt/books --filesystem=/mnt/comic
    #flatpak override --user --show com.yacreader.YACReader
    #flatpak override --user --reset com.yacreader.YACReader
}

# https://discord.com/
installDiscord() {
    textColor 3 'Install: Discord'
    curl --progress-bar -o /tmp/discord.deb -fL "https://discord.com/api/download?platform=linux&format=deb"
    # @bug Installation failed because packages missing
    #set +e
    sudo dpkg -i /tmp/discord.deb
    #set -e
    #sudo apt -y -f install
}

# https://threema.ch/
installThreema() {
    textColor 3 'Install: Threema'
    curl --progress-bar -o /tmp/threema.deb -fL "https://releases.threema.ch/web-electron/v1/release/Threema-Latest.deb"
    sudo dpkg -i /tmp/threema.deb
}

# https://signal.org/
installSignal() {
    textColor 3 'Install: Signal'
    # sudo snap install signal-desktop
    curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee /etc/apt/sources.list.d/signal-desktop.list
    sudo apt update
    sudo apt -y install signal-desktop

    cat << EOF | sudo tee /etc/xdg/autostart/signal-desktop.desktop
[Desktop Entry]
Name=Signal Desktop
GenericName=Secure messenger
Comment=Starts the main signal desktop process in the background.
Exec=/usr/bin/signal-desktop --use-tray-icon --start-in-tray --no-sandbox %U
Icon=signal-desktop
Terminal=false
Type=Application
Keywords=messenger;daemon;
Categories=Network;InstantMessaging;Chat
EOF
}

# https://signal.org/
installSignalFlatpak() {
    textColor 3 'Install: Signal (Flatpak)'
    sudo flatpak install -y flathub org.signal.Signal

    cat << EOF | sudo tee /etc/xdg/autostart/signal-desktop_flatpak.desktop
[Desktop Entry]
Name=Signal Desktop (Flatpak)
GenericName=Secure messenger
Comment=Starts the main signal desktop process in the background.
Exec=/usr/bin/flatpak run org.signal.Signal --use-tray-icon --start-in-tray --no-sandbox %U
Icon=org.signal.Signal
Terminal=false
Type=Application
Keywords=messenger;daemon;
Categories=Network;InstantMessaging;Chat
EOF
}

# https://telegram.org/
installTelegram() {
    textColor 3 'Install: Telegram'
    # @bug Problems with file permissions
    #sudo snap install telegram-desktop

    # sudo flatpak install -y flathub org.telegram.desktop

    # @todo Ubuntu 23.04 will install apt as snap
    curl --progress-bar -o /tmp/telegram.tar.xz -fL "https://telegram.org/dl/desktop/linux"
    tar -C ~/opt -xf /tmp/telegram.tar.xz
    ~/opt/Telegram/Telegram &
}

installSlack() {
    textColor 3 'Install: Slack'
    sudo snap install slack
}

installSkype() {
    textColor 3 'Install: Skype'
    sudo snap install skype
}

# https://element.io/download
installElement() {
    textColor 3 'Install: Element'
    sudo apt -y install wget apt-transport-https

    sudo curl --progress-bar -o /usr/share/keyrings/element-io-archive-keyring.gpg -fL "https://packages.element.io/debian/element-io-archive-keyring.gpg"
    echo 'deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main' | sudo tee /etc/apt/sources.list.d/element.list
    sudo apt update
    sudo apt -y install element-desktop
}

# https://zoom.us/download
installZoom() {
    textColor 3 'Install: Zoom'
    curl --progress-bar -o /tmp/zoom.deb -fL "https://zoom.us/client/latest/zoom_amd64.deb"
    #sudo apt -y install libgl1-mesa-glx libegl1-mesa libxcb-xtest0 libxcb-cursor0
    sudo apt -y install libxcb-xinerama0 libxcb-xtest0 libxcb-cursor0
    sudo dpkg -i /tmp/zoom.deb
}

# https://download.linphone.org/releases/linux/app/
installLinphone() {
    textColor 3 'Install: Linphone'
    sudo apt -y install linphone-desktop
}

# https://www.spotify.com/de/download/linux/
installSpotify() {
    textColor 3 'Install: Spotify'
    sudo snap install spotify
}

# Check if another exists like https://codeberg.org/tenacityteam/tenacity
installAudacity() {
    textColor 3 'Install: Audacity'
    sudo apt -y install audacity
}

installFreac() {
    textColor 3 'Install: fre:ac'
    sudo snap install freac
}

# https://flathub.org/apps/details/org.jdownloader.JDownloader
installJDownloader() {
    textColor 3 'Install: JDownloader'
    sudo flatpak install -y flathub org.jdownloader.JDownloader
}

installVlc() {
    textColor 3 'Install: VLC (Video Lan Client)'
    sudo apt -y install vlc
}

installMpv() {
    textColor 3 'Install: mpv'
    sudo apt -y install mpv
}

# https://flathub.org/apps/details/com.github.rafostar.Clapper
installClapper() {
    textColor 3 'Install: Clapper'
    sudo flatpak install -y flathub com.github.rafostar.Clapper
}

installKodi() {
    textColor 3 'Install: Kodi (XBMC)'
    sudo apt -y install kodi
}

installHandbrake() {
    textColor 3 'Install: Handbrake'
    sudo apt -y install handbrake
}

# https://kdenlive.org/
installKdenlive() {
    textColor 3 'Install: Kdenlive'
    #sudo add-apt-repository -y ppa:kdenlive/kdenlive-stable
    sudo apt -y install kdenlive
}

installFlowblade() {
    textColor 3 'Install: Flowblade'
    sudo apt -y install flowblade
}

# https://www.openshot.org/
installOpenShot() {
    textColor 3 'Install: OpenShot'
    local usernameRepository='OpenShot/openshot-qt'
    local VERSION=$(getGithubReleaseLatest "${usernameRepository}")

    curl --progress-bar -o /tmp/OpenShot.AppImage -fL "https://github.com/${usernameRepository}/releases/download/v${VERSION}/OpenShot-v${VERSION}-x86_64.AppImage"
    sudo install /tmp/OpenShot.AppImage /usr/local/bin/OpenShot.AppImage

    sudo curl --progress-bar -o /usr/local/share/icons/openshot.svg -fL "https://raw.githubusercontent.com/${usernameRepository}/master/images/openshot.svg"

    cat << EOF | sudo tee /usr/share/applications/OpenShot.desktop
[Desktop Entry]
Name=OpenShot Video Editor
GenericName=Video Editor
X-GNOME-FullName=OpenShot Video Editor
Comment=Create and edit amazing videos and movies
Exec="/usr/local/bin/OpenShot.AppImage" %U
Terminal=false
Type=Application
Icon=/usr/local/share/icons/openshot.svg
Categories=GNOME;GTK;AudioVideo;Video;AudioVideoEditing;
MimeType=application/vnd.openshot-qt-project;
X-AppInstall-Package=openshot-qt
X-Desktop-File-Install-Version=0.26
TryExec=/usr/local/bin/OpenShot.AppImage
EOF
}

installPitivi() {
    textColor 3 'Install: Pitivi'
    sudo apt -y install pitivi
}

installVideoEffects() {
    textColor 3 'Install: Video effects'
    sudo apt -y install frei0r-plugins
}

# https://mkvtoolnix.download/downloads.html#ubuntu
installMkvToolNix() {
    textColor 3 'Install: MkvToolNix'

    # Optional: Updates
    sudo curl --progress-bar -o /usr/share/keyrings/gpg-pub-moritzbunkus.gpg -fL "https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg"
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/ubuntu/ $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/mkvtoolnix.list
    echo "deb-src [arch=amd64 signed-by=/usr/share/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/ubuntu/ $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/mkvtoolnix.list
    sudo apt update

    sudo apt -y install mkvtoolnix mkvtoolnix-gui
}

installSubtitleEditor() {
    textColor 3 'Install: Subtitle Editor'
    sudo apt -y install subtitleeditor
}

installGwenview() {
    textColor 3 'Install: Gwenview'
    sudo apt -y install gwenview
}

# https://www.xnview.com/de/xnviewmp/
installXnview() {
    textColor 3 'Install: Xnview'

    curl --progress-bar -o /tmp/XnViewMP.deb -fL "https://download.xnview.com/XnViewMP-linux-x64.deb"
    # Fix missing
    sudo apt -y install libgdk-pixbuf2.0-0 libxcb-xinerama0
    sudo dpkg -i /tmp/XnViewMP.deb

    xnview &
    yad --center --on-top --width=400 --title "Configure XnView" --button="gtk-ok:0" --text "Run XnView, initialize config file and close it!"

    if [ -f ~/.config/xnviewmp/xnview.ini ]; then
        sudo apt -y install crudini

        # Ask close XnView
        crudini --set ~/.config/xnviewmp/xnview.ini '%General' showAgain 65536

        # Thumbnail
        crudini --set ~/.config/xnviewmp/xnview.ini 'Appearance' overlayIcons 63743
        crudini --set ~/.config/xnviewmp/xnview.ini 'Appearance' thumbLabels "1 7 "

        # Disable save session
        crudini --set ~/.config/xnviewmp/xnview.ini 'Start' session '@Invalid()'
        crudini --set ~/.config/xnviewmp/xnview.ini 'Start' sessionFlag 2

        # General > Tab: General > File startup mode = Normal
        crudini --set ~/.config/xnviewmp/xnview.ini '%General' confirmDel false

        # View > Tabs > Show = false
        crudini --set ~/.config/xnviewmp/xnview.ini '%General' useTabs false

        # Always overwrite file
        crudini --set ~/.config/xnviewmp/xnview.ini '%General' showAgain 65544
        crudini --set ~/.config/xnviewmp/xnview.ini '%General' showAgainResults '@Variant(\0\0\0\b\0\0\0\x1\0\0\0\x2\0\x38\0\0\0\x2\0\0\x4\0)'

        # General > Tab: File operations > Confirm file delete = false
        crudini --set ~/.config/xnviewmp/xnview.ini 'Start' startInFull 0

        # View > Tab: View > High quality zoom = Zoom-out & Zoom-in
        crudini --set ~/.config/xnviewmp/xnview.ini 'Viewer' zoomQuality 3

        # View > Tab: View > Auto image size > Fit image to window
        crudini --set ~/.config/xnviewmp/xnview.ini 'Viewer' defaultFit 2

        # Fullscreen > Tab: Fullscreen > Auto image size > Fit image to window
        crudini --set ~/.config/xnviewmp/xnview.ini 'Viewer' defaultFullscreenFit 2

        # Fullscreen > Tab: Fullscreen > Show informations = false
        crudini --set ~/.config/xnviewmp/xnview.ini 'Viewer' useInfo false

        # Fullscreen > Tab: Fullscreen > Auto show areas = false
        crudini --set ~/.config/xnviewmp/xnview.ini 'Viewer' fullFloatView false

        # Fullscreen > Background Color = black
        crudini --set ~/.config/xnviewmp/xnview.ini 'Viewer' fullBackColor "0 0 0"

        # Image management > Files > Tab: Custom filter
        crudini --set ~/.config/xnviewmp/xnview.ini 'Browser' customFilter 3269

        # Sort by filename
        crudini --set ~/.config/xnviewmp/xnview.ini 'Browser' sort 0
    fi
}

installGimp() {
    textColor 3 'Install: Gimp'
    sudo apt -y install gimp
}

installKrita() {
    textColor 3 'Install: Krita'
    sudo apt -y install krita
}

installInkscape() {
    textColor 3 'Install: Inkscape'
    sudo apt -y install inkscape
}

# https://www.drawio.com/
installDrawioSnap() {
    textColor 3 'Install: Draw.io'
    sudo snap install drawio
}
installDrawioFlatpak() {
    textColor 3 'Install: Draw.io'
    sudo flatpak install -y flathub com.jgraph.drawio.desktop
}

# https://github.com/qarmin/czkawka
installCzkawka() {
    textColor 3 'Install: Czkawka'
    local usernameRepository='qarmin/czkawka'
    local VERSION=$(getGithubReleaseLatest "${usernameRepository}")
    curl --progress-bar -o /tmp/czkawka-gui -fL "https://github.com/${usernameRepository}/releases/download/${VERSION}/linux_czkawka_gui"
    sudo install /tmp/czkawka-gui /usr/local/bin/czkawka-gui

    sudo curl --progress-bar -o /usr/local/share/icons/czkawka.png -fL "https://raw.githubusercontent.com/${usernameRepository}/master/czkawka_gui/icons/icon_about.png"

    cat << EOF | sudo tee /usr/share/applications/Czkawka.desktop
[Desktop Entry]
Name=Czkawka
Comment=Czkawka is a app to remove unnecessary files from your computer.
Exec=/usr/local/bin/czkawka-gui
TryExec=/usr/local/bin/czkawka-gui
Terminal=false
Type=Application
Icon=/usr/local/share/icons/czkawka.png
StartupWMClass=czkawka
Categories=Utility;
EOF
}

# https://flameshot.org/
installFlameshot() {
    textColor 3 'Install: Flameshot'
    # sudo flatpak install -y flathub org.flameshot.Flameshot
    # sudo snap install flameshot
    sudo apt -y install flameshot
}

installVokoScreen() {
    textColor 3 'Install: VokoScreen'
    sudo apt -y install vokoscreen
}

# https://obsproject.com/
installObsStudio() {
    textColor 3 'Install: OBS Studio'

    # Optional
    sudo add-apt-repository -y ppa:obsproject/obs-studio
    sudo apt update

    sudo apt -y install obs-studio v4l2loopback-dkms ffmpeg
}

# https://obsproject.com/
installObsStudioFlatpak() {
    textColor 3 'Install: OBS Studio (Flatpak)'
    sudo flatpak install -y flathub com.obsproject.Studio
}

installVideoTools() {
    textColor 3 'Install: Video tools'
    sudo apt -y install ffmpeg
}

installConky() {
    sudo apt -y install conky-all
}

# https://www.hoptodesk.com/
installHopToDesk() {
    textColor 3 'Install: HopToDesk'
    curl --progress-bar -o /tmp/hoptodesk.deb -fL "https://www.hoptodesk.com/hoptodesk.deb"
    # Fix missing packages
    sudo apt -y install libxdo3
    sudo dpkg -i /tmp/hoptodesk.deb
}

# https://rustdesk.com/
installRustDesk() {
    textColor 3 'Install: RustDesk'
    local usernameRepository='rustdesk/rustdesk'
    local URL=$(getGithubReleaseLatestFileUrl "${usernameRepository}" 'rustdesk-\d+\.\d+\.\d+.*-x86_64.deb')
    curl --progress-bar -o /tmp/rustdesk.deb -fL "${URL}"
    # Fix missing packages
    sudo apt -y install libxdo3
    sudo dpkg -i /tmp/rustdesk.deb
}

# https://teamviewer.com/
installTeamViewer() {
    textColor 3 'Install: TeamViewer'
    curl --progress-bar -o /tmp/teamviewer.deb -fL "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
    # Fix missing packages
    sudo apt -y install libminizip1t64 libxcb-xinerama0
    sudo dpkg -i /tmp/teamviewer.deb

    # @fixme: Key is stored in deprecated trusted.gpg keychain
    #sudo apt-key export 8CAE012EBFAC38B17A937CD8C5E224500C1289C0 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/teamviewer -2017.gpg
    #sudo apt-key export D2A5FEB3488160F028CC17918DA84BE5DEB49217 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/teamviewer.gpg
}

# https://anydesk.com/
installAnyDesk() {
    textColor 3 'Install: AnyDesk'

    # Note: Own fix
    wget -q https://keys.anydesk.com/repos/DEB-GPG-KEY -O- | sudo tee /etc/apt/keyrings/packages.anydesk.asc 1>/dev/null
    fingerprint=$(gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.anydesk.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); print $0}')
    if [ "${fingerprint}" != "06B5EA2FAE208E7CDA9761DCA2FB21D5A8772835" ]; then
        echo "Verification failed: The fingerprint (${fingerprint}) does not match!"; exit 1;
    fi
    echo "deb [signed-by=/etc/apt/keyrings/packages.anydesk.asc] http://deb.anydesk.com/ all main" | sudo tee -a /etc/apt/sources.list.d/anydesk.list 1>/dev/null
    sudo apt update
    sudo apt -y install anydesk
}

installNoMachine() {
    textColor 3 'Install: NoMachine'
    # NoMachine Linux 64bit - https://downloads.nomachine.com/linux/?id=1
    local NOMACHINE_VERSION="8.11.3_4"
    local NOMACHINE_MD5="1a128694ee00853e59149dc8b2af1baf"
    local NOMACHINE_OS="Linux" && NOMACHINE_ARCHITECTURE="amd64"
    local NOMACHINE_VERSION_SHORT=`echo ${NOMACHINE_VERSION} | cut -d. -f1-2`
    curl --progress-bar -o /tmp/nomachine.deb -fL "https://download.nomachine.com/download/${NOMACHINE_VERSION_SHORT}/${NOMACHINE_OS}/nomachine_${NOMACHINE_VERSION}_${NOMACHINE_ARCHITECTURE}.deb"

    if ! echo "${NOMACHINE_MD5} /tmp/nomachine.deb" | md5sum -c -; then
        yad --center --on-top --image="gtk-dialog-error" --width=400 --title "NoMachine" --button="gtk-close:1" --text "Error installing NoMachine!\nMD5 checksum not match!"
    else
        sudo dpkg -i /tmp/nomachine.deb
    fi
}

# https://github.com/balena-io/etcher
installBalenaEtcher() {
    textColor 3 'Install: Balena Etcher'
    local usernameRepository='balena-io/etcher'
    local VERSION=$(getGithubReleaseLatest "${usernameRepository}")
    curl --progress-bar -o /tmp/etcher.deb -fL "https://github.com/${usernameRepository}/releases/download/v${VERSION}/balena-etcher_${VERSION}_amd64.deb"

    ## Fix
    sudo apt -y install gconf2 gconf-service libgconf-2-4

    sudo dpkg -i /tmp/etcher.deb

    # @fixme: Key is stored in deprecated trusted.gpg keychain
    #sudo apt-key export 8F40D32ABF59D635B11612F270528471AFF9A051 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/balena-etcher.gpg
}

installK3b() {
    textColor 3 'Install: K3b'
    sudo apt -y install k3b
}

installXfburn() {
    textColor 3 'Install: Xfburn'
    sudo apt -y install xfburn
}

installBrasero() {
    textColor 3 'Install: Brasero'
    sudo apt -y install brasero
}

installPlayOnLinux() {
    textColor 3 'Install: Play on Linux'
    sudo apt -y install playonlinux
}

# https://steampowered.com/
installSteam() {
    textColor 3 'Install: Steam'
    sudo apt -y install steam
}

# https://syncthing.net/
installSyncthing() {
    textColor 3 'Install: Syncthing'
    sudo curl --progress-bar -o /usr/share/keyrings/syncthing-archive-keyring.gpg -fL "https://syncthing.net/release-key.gpg"
    echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
    sudo apt update
    sudo apt install syncthing

    curl --progress-bar -o ~/.config/autostart/syncthing-start.desktop -fL "https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-desktop/syncthing-start.desktop"
    curl --progress-bar -o ~/.local/share/applications/syncthing-ui.desktop -fL "https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-desktop/syncthing-ui.desktop"
}

# https://nextcloud.com/
installNextcloudDesktop() {
    textColor 3 'Install: Nextcloud Desktop'

    local usernameRepository='nextcloud-releases/desktop'
    local VERSION=$(getGithubReleaseLatest "${usernameRepository}")
    curl --progress-bar -o /tmp/nextcloud.AppImage -fL "https://github.com/${usernameRepository}/releases/download/v${VERSION}/Nextcloud-${VERSION}-x86_64.AppImage"
    sudo install /tmp/nextcloud.AppImage /usr/local/bin/nextcloud.AppImage

    local usernameRepository='nextcloud/desktop'
    sudo curl --progress-bar -o /usr/local/share/icons/nextcloud.svg -fL "https://raw.githubusercontent.com/${usernameRepository}/master/theme/colored/Nextcloud-icon.svg"

    cat << EOF | sudo tee /usr/share/applications/nextcloud.desktop
[Desktop Entry]
Categories=Utility;X-SuSE-SyncUtility;
Type=Application
Exec=/usr/local/bin/nextcloud.AppImage
Name=Nextcloud Desktop
Comment=Nextcloud desktop synchronization client
GenericName=Folder Sync
Icon=/usr/local/share/icons/nextcloud.svg
Keywords=Nextcloud;syncing;file;sharing;
X-GNOME-Autostart-Delay=3
Actions=Quit;
Comment[de]=Nextcloud Desktop-Synchronisationsclient
GenericName[de]=Ordner-Synchronisation
Name[de]=Nextcloud Desktop-Synchronisationsclient
Comment[de_DE]=Nextcloud Desktop-Synchronisationsclient
GenericName[de_DE]=Ordner-Synchronisation
Name[de_DE]=Nextcloud Desktop-Synchronisationsclient

[Desktop Action Quit]
Exec=/usr/local/bin/nextcloud.AppImage --quit
Name=Quit Nextcloud
Icon=/usr/local/bin/nextcloud.AppImage
Name[de]=Nextcloud Beenden
EOF
}

# https://www.dropbox.com/install
installDropbox() {
    textColor 3 'Install: Dropbox'
    # @bug: Key is stored in deprecated trusted.gpg keychain
    curl --progress-bar -o /tmp/dropbox.deb -fL "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2024.01.22_amd64.deb"
    #old: sudo apt -y install libpango1.0-0 python3-gpg
    #sudo apt -y install libpango-1.0-0 python3-gpg
    sudo dpkg -i /tmp/dropbox.deb
}

# https://restic.net/
installRestic() {
    textColor 3 'Install: Restic'
    sudo apt -y install restic
    #sudo restic self-update
}

# https://rdiff-backup.net/
installRdiffBackup() {
    textColor 3 'Install: RdiffBackup'
    sudo apt -y install rdiff-backup
}

# https://github.com/schollz/croc
installCroc() {
    textColor 3 'Install: Croc'
    curl https://getcroc.schollz.com | bash
}

installAria2() {
    textColor 3 'Install: Aria2'
    sudo apt -y install aria2
}

installDeluge() {
    textColor 3 'Install: Deluge'
    sudo apt -y install deluge
}

# https://flathub.org/apps/com.vixalien.sticky
# https://www.vixalien.com/
installVixalienStickyNotes() {
    textColor 3 'Install: VSCodium'
    sudo flatpak install -y flathub com.vixalien.sticky
}

# https://vscodium.com/
installVSCodium() {
    textColor 3 'Install: VSCodium'
    sudo snap install codium --classic
}

# https://code.visualstudio.com/
installVisualStudioCode() {
    textColor 3 'Install: Visual Studio Code'
    sudo snap install code --classic
}

# https://www.jetbrains.com/phpstorm/
installPhpStorm() {
    textColor 3 'Install: PhpStorm'
    sudo snap install phpstorm --classic
}

# https://meldmerge.org/
installMeld() {
    textColor 3 'Install: Meld'
    sudo apt -y install meld
}

# https://github.com/jqlang/jq
installJqYqXq() {
    textColor 3 'Install: Jq, Yq, Xq (Json/Yaml/Xml processor)'
    sudo apt -y install jq yq
    #sudo apt -y install jq python3 python3-pip
    #sudo pip3 install yq
}

# https://go.dev/
installGo() {
    textColor 3 'Install: Go-Lang'
    sudo snap install go --classic
}

# https://filezilla-project.org/
installFileZilla() {
    textColor 3 'Install: FileZilla'
    sudo apt -y install filezilla
}

# https://www.heidisql.com/download.php
installHeidiSql() {
    textColor 3 'Install: HeidiSQL'
    local VERSION='12.7.0.6850'

    if [ ! -d ~/Dokumente/HeidiSQL ]; then mkdir -p ~/Dokumente/HeidiSQL; fi
    if [ -d ~/Dokumente/HeidiSQL/../../Sync/notes/Programming/SQL ] && [ ! -d ~/Dokumente/HeidiSQL/Snippets ]; then
        ln -s ../../Sync/notes/Programming/SQL ~/Dokumente/HeidiSQL/Snippets
    fi

    curl --progress-bar -o /tmp/heidisql.exe -fL "https://www.heidisql.com/installers/HeidiSQL_${VERSION}_Setup.exe"
    wine /tmp/heidisql.exe
}

# https://www.chiark.greenend.org.uk/~sgtatham/putty/
installPutty() {
    textColor 3 'Install: PuTTY'
    curl --progress-bar -o /tmp/putty.zip -fL "https://the.earth.li/~sgtatham/putty/latest/w64/putty.zip"
    mkdir -p ~/.wine/drive_c/Program\ Files\ \(x86\)/PuTTY
    unzip /tmp/putty.zip -d ~/.wine/drive_c/Program\ Files\ \(x86\)/PuTTY
}

# https://www.virtualbox.org/
installVirtualBox() {
    textColor 3 'Install: VirtualBox'
    echo 'virtualbox-ext-pack virtualbox-ext-pack/license select true' | sudo debconf-set-selections
    sudo apt -y install virtualbox virtualbox-ext-pack
    #sudo systemctl disable vboxweb.service
}

installUbuntuRestrictedExtras() {
    textColor 3 'Install: Ubuntu Restricted Extras'

    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
    sudo apt-get install ttf-mscorefonts-installer

    sudo apt -y install ubuntu-restricted-extras
}

# https://peterlevi.com/variety/
installVariety() {
    textColor 3 'Install: Variety'
    #sudo add-apt-repository -y ppa:variety/stable
    #sudo apt -y install variety variety-slideshow
    sudo apt -y install variety
}

installUefiRebootLauncher() {
    textColor 3 'Install: UEFI Firmware Setup Reboot Launcher'
    cat << EOF | sudo tee /usr/share/applications/uefi-reboot.desktop
[Desktop Entry]
Name=UEFI Firmware Setup (Reboot)
Comment=Access the motherboard configuration utility
Exec=/bin/bash -c 'if [[ "$(ps --no-headers -o comm 1)" == "systemd" ]]; then if zenity --title="Reboot to UEFI Firmware Setup" --icon-name=warning --question --text="Do you want to reboot to UEFI Firmware Setup?"; then systemctl reboot --firmware-setup; fi; else zenity --error --text="Error Systemd not found!"; fi'
Icon=system-restart
Terminal=false
Type=Application
Categories=System;Settings;
EOF
}

# https://bitwarden.com/
installBitwarden() {
    textColor 3 'Install: Bitwarden'
    sudo snap install bitwarden
}

# https://keepassxc.org/
installKeePassXC() {
    textColor 3 'Install: KeePassXC'
    sudo apt -y install keepassxc
}

# Installation #################################################################
removePackages() {
    #textColor 3 'Remove Software (APT)'
    #packages=($(yad --center --window-icon="gtk-ok" --on-top --width=600 --height=400 --title="Remove Software" \
    #    --list --checklist --multiple --separator=" " \
    #    --column=" " --column="Action" --column="Application" --column="Description" \
    #    --search-column=3 --hide-column=2 --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
    #    "TRUE" "totem" "Totem" "Video player" \
    #))
    #sudo apt -y remove "${packages[@]}"
    #sudo apt -y auto-remove

    if command -v snap &>/dev/null; then
        selectedList=($(yad --center --window-icon="gtk-ok" --on-top --width=600 --height=400 --title="Remove Software (Snap)" \
            --list --checklist --multiple --separator=" " \
            --column=" " --column="Action" --column="Application" --column="Description" \
            --search-column=3 --hide-column=2 --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
            "TRUE" "removeFirefoxSnap" "Remove Firefox" "Web Browser" \
        ))
        for selected in "${selectedList[@]}"; do
            ${selected}
        done
    fi
}

# https://github.com/eza-community/eza
# https://github.com/junegunn/fzf
installEssential() {
    textColor 3 'Install: Essential'
    sudo apt -y install git aria2 curl jq

    packages=($(yad --center --on-top --width=600 --height=400 --title="Install Essential" \
        --list --checklist --multiple --separator=" " \
        --column=" " --column="Action" --column="Application" --column="Description" \
        --search-column=3 --hide-column=2 --print-column=2 \
        "TRUE" "cifs-utils nfs-common sshfs" "File system tools" "Tools for SSH, Samba and NFS" \
        "TRUE" "vim" "Vim" "Text editor" \
        "TRUE" "ncdu" "Ncdu" "NCurses Disk Usage" \
        "TRUE" "eza" "Eza" "Prettier list filesystem" \
        "TRUE" "fzf" "fzf" "Fuzzy finder" \
        "TRUE" "duf" "Duf" "Disk Usage Utility" \
        "TRUE" "htop" "Htop" "Interactive process viewer" \
        "TRUE" "inxi" "Inxi" "System information script" \
        "TRUE" "testdisk extundelete" "Recover files" "Packages: testdisk, extundelete" \
        "TRUE" "p7zip-full p7zip-rar" "7-Zip" "Compression tools (+7-Zip-Rar)" \
        "TRUE" "rar unrar-free" "Rar" "Compression tools" \
        "TRUE" "diffutils" "Diff Utils" "Compare files" \
        "TRUE" "gparted" "GParted" "Partition Editor" \
        "TRUE" "exfatprogs" "exFAT" "Dateisystem" \
        "TRUE" "iputils-ping" "IPutils Ping" "Send ICMP ECHO_REQUEST to network hosts" \
        "FALSE" "openssh-server" "OpenSSH Server" "Server for Secure Shell" \
    ))
    sudo apt -y install "${packages[@]}"

    if [[ ${packages[@]} =~ 'vim' ]]; then
        sudo update-alternatives --set editor /usr/bin/vim.basic
    fi
}

installDependencies() {
    notExistsFlatpak=$([ ! -e /usr/bin/flatpak ] && echo 'TRUE' || echo 'FALSE')
    notExistsWine=$([ ! -e /usr/bin/wine ] && echo 'TRUE' || echo 'FALSE')
    notExistsDocker=$([ ! -e /usr/bin/docker ] && echo 'TRUE' || echo 'FALSE')
    selectedList=($(yad --center --on-top --width=600 --height=300 --title="Install Dependencies" \
        --list --checklist --multiple --separator=" " \
        --column=" " --column="Action" --column="Application" --column="Description" \
        --search-column=3 --hide-column=2 --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
        "${notExistsFlatpak}" "installFlatpak" "Flatpak" "Package manager" \
        "${notExistsWine}" "installWine" "Wine" "Run Windows applications" \
        "${notExistsDocker}" "installDocker" "Docker" "Container Virtualisation" \
        "${notExistsDocker}" "installDockerCompose" "Docker Compose" "Container Virtualisation" \
        "TRUE" "reboot" "Reboot" "Reboot System" \
    ))
    for selected in "${selectedList[@]}"; do
        ${selected}
    done
}

installSoftware() {
    set +e
    yad --center --on-top --image="gtk-dialog-warning" --width=300 --title "Preselect Software" \
        --button="Use Bash Variable:4" --button="Nothing:3" --button="All:1" --button="Recommed:0" --text "Do you wan't to preselect Software?"
    REPLY=$?
    if [ ${REPLY} -eq 0 ]; then
       TICK=""
    elif [ ${REPLY} -eq 1 ]; then
       TICK="TRUE"
    elif [ ${REPLY} -eq 3 ]; then
       TICK="FALSE"
    fi
    set -e

    selectedList=($(yad --center --window-icon="gtk-ok" --width=800 --height=600 --title="Install Software" \
        --list --checklist --multiple --separator=" " \
        --column=" " --column="Action" --column="Application" --column="Description" --column="Source" \
        --search-column=3 --hide-column=2 --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
        --expand-column=4 \
        "${TICK:-FALSE}" "installFirefoxFlatpak" "Firefox (Flatpak)" "Webbrowser" "Flatpak" \
        "${TICK:-FALSE}" "installFirefoxSnap" "Firefox (Snap)" "Webbrowser" "Snap" \
        "${TICK:-TRUE}" "installFirefoxForceAptMozilla" "Firefox (Force Apt Mozilla) (Recommended)" "Webbrowser directly from mozilla repository" "Apt" \
        "${TICK:-FALSE}" "installFirefoxForceAptPPA" "Firefox (Force Apt PPA)" "Webbrowser directly from mozilla repository" "Apt" \
        "${TICK:-TRUE}" "installChromiumSnap" "Chromium (Snap)" "Webbrowser" "Snap" \
        "${TICK:-FALSE}" "installThunderbird" "Thunderbird" "Mail client" "Apt" \
        "${TICK:-TRUE}" "installThunderbirdSnap" "Thunderbird" "Mail client" "Snap" \
        "${TICK:-TRUE}" "installLibreOffice" "LibreOffice" "Office Suite" "Apt" \
        "${TICK:-TRUE}" "installPdfArranger" "PDF Arranger" "PDF Arranger" "Apt" \
        "${TICK:-FALSE}" "installFluentReader" "Fluent Reader" "RSS Reader" "Github" \
        "${TICK:-FALSE}" "installCalibre" "Calibre" "EBook Reader (epub)" "Apt" \
        "${TICK:-FALSE}" "installComix" "Comix (mComix)" "Comic Book Reader (cbz, cbr)" "Apt" \
        "${TICK:-TRUE}" "installYacReaderFlatpak" "YACReader" "Comic Book Reader (cbz, cbr)" "Flatpak" \
        "${TICK:-TRUE}" "installDiscord" "Discord" "Instant messaging, Chat, Voice conferencing" "Debian Repository" \
        "${TICK:-TRUE}" "installThreema" "Threema" "Instant messaging, Voice conferencing" "Debian Repository" \
        "${TICK:-FALSE}" "installSignal" "Signal" "Instant messaging, Voice conferencing" "Debian Repository" \
        "${TICK:-TRUE}" "installSignalFlatpak" "Signal (Flatpak)" "Instant messaging, Voice conferencing" "Flatpak" \
        "${TICK:-TRUE}" "installTelegram" "Telegram" "Instant messaging, Voice conferencing" "Archive" \
        "${TICK:-FALSE}" "installSlack" "Slack" "Instant messaging, Voice conferencing" "Snap" \
        "${TICK:-FALSE}" "installSkype" "Skype" "Instant messaging, Voice conferencing" "Snap" \
        "${TICK:-FALSE}" "installElement" "Element" "Instant messaging" "Debian Repository" \
        "${TICK:-TRUE}" "installZoom" "Zoom" "Zoom meeting client" "Debian Package" \
        "${TICK:-FALSE}" "installLinphone" "Linphone" "Voice conferencing" "Apt" \
        "${TICK:-TRUE}" "installSpotify" "Spotify" "Audio streaming" "Snap" \
        "${TICK:-TRUE}" "installAudacity" "Audacity" "Audio editor" "Apt" \
        "${TICK:-FALSE}" "installFreac" "fre:ac" "Audio converter and CD ripper" "Snap" \
        "${TICK:-TRUE}" "installJDownloader" "JDownloader" "Download manager" "Flatpak" \
        "${TICK:-TRUE}" "installVlc" "VLC (Video Lan Client)" "Video player" "Apt" \
        "${TICK:-TRUE}" "installMpv" "mpv" "Video player" "Apt" \
        "${TICK:-FALSE}" "installClapper" "Clapper" "Video player" "Flatpak" \
        "${TICK:-FALSE}" "installKodi" "Kodi (XBMC)" "Media center" "Apt" \
        "${TICK:-TRUE}" "installHandbrake" "Handbrake" "Video transcoder" "Apt" \
        "${TICK:-TRUE}" "installKdenlive" "Kdenlive" "Video editor" "Apt+PPA" \
        "${TICK:-FALSE}" "installFlowblade" "Flowblade" "Video editor" "Apt" \
        "${TICK:-FALSE}" "installOpenShot" "OpenShot" "Video editor" "Github" \
        "${TICK:-FALSE}" "installPitivi" "Pitivi" "Video editor" "Apt" \
        "${TICK:-TRUE}" "installVideoEffects" "Video effects" "Video effects" "Apt" \
        "${TICK:-TRUE}" "installMkvToolNix" "MkvToolNix" "Matroska media container tools" "Apt + Repository" \
        "${TICK:-TRUE}" "installSubtitleEditor" "Subtitle Editor" "" "Apt" \
        "${TICK:-TRUE}" "installGwenview" "Gwenview" "Image viewer" "Apt" \
        "${TICK:-TRUE}" "installXnview" "Xnview" "Image viewer" "Debian Package + Config" \
        "${TICK:-TRUE}" "installGimp" "Gimp" "Image editor" "Apt" \
        "${TICK:-TRUE}" "installKrita" "Krita" "Image editor" "Apt" \
        "${TICK:-TRUE}" "installInkscape" "Inkscape" "Vector image editor" "Apt" \
        "${TICK:-FALSE}" "installDrawioSnap" "Draw.io" "Create diagrams" "Snap" \
        "${TICK:-TRUE}" "installDrawioFlatpak" "Draw.io" "Create diagrams" "Flatpak" \
        "${TICK:-TRUE}" "installCzkawka" "Czkawka" "Duplicate image finder" "Github" \
        "${TICK:-TRUE}" "installFlameshot" "Flameshot" "Screenshot tools" "Apt" \
        "${TICK:-FALSE}" "installVokoScreen" "VokoScreen" "Screen recorder" "Apt" \
        "${TICK:-FALSE}" "installObsStudio" "ObsStudio" "Screen recorder" "Apt + Repository" \
        "${TICK:-TRUE}" "installObsStudioFlatpak" "ObsStudio (Flatpak)" "Screen recorder" "Flatpak" \
        "${TICK:-TRUE}" "installVideoTools" "Video tools" "ffmpeg" "Apt" \
        "${TICK:-TRUE}" "installConky" "Conky" "Desktop tools" "Apt" \
        "${TICK:-TRUE}" "installHopToDesk" "HopToDesk" "Remote maintenance" "Debian Package" \
        "${TICK:-TRUE}" "installRustDesk" "RustDesk" "Remote maintenance" "Git + Debian Package" \
        "${TICK:-TRUE}" "installTeamViewer" "TeamViewer" "Remote maintenance" "Debian Package" \
        "${TICK:-TRUE}" "installAnyDesk" "AnyDesk" "Remote maintenance" "Debian Repository" \
        "${TICK:-TRUE}" "installNoMachine" "NoMachine" "Remote maintenance" "Debian Package" \
        "${TICK:-TRUE}" "installBalenaEtcher" "Balena Etcher" "USB burning tool" "Debian Package" \
        "${TICK:-TRUE}" "installK3b" "K3b" "Disc burning tool" "Apt" \
        "${TICK:-FALSE}" "installXfburn" "Xfburn" "Disc burning tool" "Apt" \
        "${TICK:-FALSE}" "installBrasero" "Brasero" "Disc burning tool" "Apt" \
        "${TICK:-FALSE}" "installPlayOnLinux" "PlayOnLinux" "Create multiple Wine prefixes" "Apt" \
        "${TICK:-TRUE}" "installSteam" "Steam" "Game client" "Apt" \
        "${TICK:-TRUE}" "installSyncthing" "Syncthing" "Sycronisation tool" "Debian Repository" \
        "${TICK:-FALSE}" "installNextcloudDesktop" "Nextcloud Desktop" "Sycronisation tool" "AppImage" \
        "${TICK:-FALSE}" "installDropbox" "Dropbox" "Sycronisation tool" "Debian Package" \
        "${TICK:-TRUE}" "installRestic" "Restic" "Backup tool" "Apt + Self" \
        "${TICK:-TRUE}" "installRdiffBackup" "RdiffBackup" "Backup tool" "Apt" \
        "${TICK:-TRUE}" "installCroc" "Croc" "File transfer tool" "External" \
        "${TICK:-TRUE}" "installAria2" "Aria2" "File download tool" "Apt" \
        "${TICK:-FALSE}" "installDeluge" "Deluge" "BitTorrent client" "Apt" \
        "${TICK:-FALSE}" "installVixalienStickyNotes" "Sticky Votes" "Sticky Notes (vixalien)" "Flatpak" \
        "${TICK:-TRUE}" "installVSCodium" "VSCodium" "Visual Studio Code but without Microsoft" "Snap Classic" \
        "${TICK:-FALSE}" "installVisualStudioCode" "Visual Studio Code" "Editor, IDE (Integrated Development Environment)" "Snap Classic" \
        "${TICK:-FALSE}" "installPhpStorm" "PhpStorm" "Editor, IDE (Integrated Development Environment)" "Snap Classic" \
        "${TICK:-TRUE}" "installMeld" "Meld" "Visual diff and merge tool" "Apt" \
        "${TICK:-TRUE}" "installJqYqXq" "Jq, Yq, Xq" "Json/Yaml/Xml processor" "Apt + Python" \
        "${TICK:-FALSE}" "installGo" "Go-Lang" "Go language" "Snap Classic" \
        "${TICK:-TRUE}" "installFileZilla" "FileZilla" "FTP/SFTP Client" "Apt" \
        "${TICK:-TRUE}" "installHeidiSql" "HeidiSQL" "FTP/SFTP Client" "Wine" \
        "${TICK:-TRUE}" "installPutty" "PuTTY" "PuTTY utilities" "Wine" \
        "${TICK:-TRUE}" "installVirtualBox" "VirtualBox" "Virtual machines" "Apt" \
        "${TICK:-TRUE}" "installBitwarden" "Bitwarden" "Password manager" "Snap" \
        "${TICK:-TRUE}" "installKeePassXC" "KeePassXC" "Password manager" "Apt" \
        "${TICK:-TRUE}" "installUbuntuRestrictedExtras" "Ubuntu Restricted Extras" "Ubuntu Restricted Extras" "Apt" \
        "${TICK:-TRUE}" "installVariety" "Variety" "Background changer" "Debian Repository" \
        "${TICK:-TRUE}" "installUefiRebootLauncher" "UEFI Launcher" "UEFI Firmware Setup Launcher: Reboot" "Script" \
    ))
    for selected in "${selectedList[@]}"; do
        ${selected}
    done
}

updateSoftware() {
    selectedList=($(yad --center --window-icon="gtk-ok" --width=600 --height=600 --title="Update Software" \
        --list --checklist --multiple --separator=" " \
        --column=" " --column="Action" --column="Application" --column="Description" \
        --search-column=3 --hide-column=2 --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
        "FALSE" "installCroc" "Croc" "File transfer tool" \
        "FALSE" "installRestic" "Restic" "Backup tool" \
        "FALSE" "installCzkawka" "Czkawka" "Duplicate image finder" \
        "FALSE" "installDiscord" "Discord" "Instant messaging, Chat, Voice conferencing" \
        "FALSE" "installFluentReader" "Fluent Reader" "RSS Reader" \
        "FALSE" "installHeidiSql" "HeidiSQL" "FTP/SFTP Client" \
        "FALSE" "installNextcloudDesktop" "Nextcloud Desktop" "Sycronisation tool" \
        "FALSE" "installOpenShot" "OpenShot" "Video editor" \
        "FALSE" "installPutty" "PuTTY" "PuTTY utilities" \
        "FALSE" "installRustDesk" "RustDesk" "Remote maintenance" \
        "FALSE" "installThreema" "Threema" "Instant messaging, Voice conferencing" \
        "FALSE" "installXnview" "Xnview" "Image viewer" \
        "FALSE" "installYacReader" "YACReader" "Comic Book Reader (cbz, cbr)" \
        "FALSE" "installZoom" "Zoom" "Zoom meeting client" \
    ))
    for selected in "${selectedList[@]}"; do
        ${selected}
    done
}

TICK="${1:-}"
if [[ "${1}" == "true" ]]; then
    TICK='TRUE'
elif [[ "${1}" == "false" ]]; then
    TICK='FALSE'
fi

# Better to ask what should be started
checkCurlInstalled
checkYadInstalled
prepareSystem

selectedList=($(yad --center --window-icon="gtk-ok" --on-top --width=350 --height=250 --title="Installation Process" \
    --list --checklist --multiple --separator=" " \
    --column=" " --column="Action" --column="Application" \
    --search-column=3 --hide-column=2 --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
    "${TICK:-FALSE}" "configure" "Configure" \
    "${TICK:-TRUE}" "systemUpdate" "System update" \
    "${TICK:-FALSE}" "removePackages" "Remove Packages" \
    "${TICK:-FALSE}" "installEssential" "Install Essential" \
    "${TICK:-FALSE}" "installDependencies" "Install Dependencies: Flatpak, Wine, Docker" \
    "${TICK:-FALSE}" "installSoftware" "Install Software" \
    "${TICK:-TRUE}" "updateSoftware" "Update Software" \
))
for selected in "${selectedList[@]}"; do
    ${selected}
done

#if [ ! -f /tmp/ubuntu-installation.lock ]; then
    #yad --center --on-top --image="gtk-dialog-info" --width=400 --title "Prepare System" \
    #    --button="gtk-close:1" --button="gtk-ok:0" --text "Prepare System?"
    #if [ $? -eq 0 ]; then
 #       configure
 #       prepareSystem
    #fi

  #  installEssential
  #  installDependencies

   # touch /tmp/ubuntu-installation.lock
#fi

#installSoftware

textColor 2 "# Script success"
