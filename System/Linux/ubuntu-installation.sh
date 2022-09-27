#!/usr/bin/env bash

# wget -O - https://raw.githubusercontent.com/Cyb10101/notes/master/System/Linux/ubuntu-installation.sh | bash

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

textColor() {
    echo -e "\033[0;3${1}m${2}\033[0m"
}

checkYadInstalled() {
  if ! hash yad 2>/dev/null; then
    textColor 3 "# Install: Yad"
    sudo apt update
    sudo apt -y install yad
  fi
  if ! hash yad 2>/dev/null; then
    textColor 1 "Yad is not installed. Aborting!"
    exit 1;
  fi
}

getUsername() {
    local selectedUsername=($(yad --on-top --width=600 --height=200 --title="Select User" \
        --list --radiolist --separator=" " \
        --column=" " --column="Username" \
        --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
        "TRUE" "cyb10101" \
        "FALSE" "user" \
    ))
    echo "${selectedUsername}"
}

# VERSION=$(getGithubReleaseLatest 'username/repository')
getGithubReleaseLatest() {
    local usernameRepository="${1}"
    local VERSION=$(curl -fsSL https://api.github.com/repos/${usernameRepository}/releases/latest | jq -r '.tag_name' | sed -r 's/v//g');
    echo "${VERSION}"
}

# Script #######################################################################
reboot() {
    set +e
    yad --on-top --image="gtk-dialog-warning" --width=300 --title "Reboot" \
        --button="gtk-cancel:1" --button="gtk-ok:0" --text "Reboot System?"
    if [ $? -eq 0 ]; then
       sudo reboot
       exit
    fi
    set -e
}

configureEnergy() {
    textColor 3 'Configure: Energy'
    selected=$(yad --on-top --width=400 --height=200 --title="Configure Energy" --list --separator="" \
        --print-column=1 --column="Action" --column="Description" \
        "Default" "Default: Monitor off in 15 minutes" \
        "Development" "Monitor always on" \
    )

    if [ "${selected}" == "Development" ]; then
        gsettings set org.gnome.desktop.session idle-delay 0
        gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
    else
        # Monitor off in 15 minutes
        gsettings set org.gnome.desktop.session idle-delay 900
    fi
}

prepareSystem() {
    sudo add-apt-repository -y multiverse
    sudo apt update && sudo apt -y full-upgrade

    if [ ! -d ~/opt ]; then
        mkdir -p ~/opt
    fi
}

removePackages() {
    textColor 3 'Prepare System'
    packages=($(yad --on-top --width=600 --height=400 --title="Remove Software" \
        --list --checklist --multiple --separator=" " \
        --column=" " --column="Action" --column="Application" --column="Description" \
        --search-column=3 --hide-column=2 --print-column=2 \
        "TRUE" "aisleriot" "AisleRiot" "Solitaire game" \
        "TRUE" "gnome-mahjongg" "Mahjongg" "Mahjongg game" \
        "TRUE" "gnome-mines" "Mines" "Mines game" \
        "TRUE" "gnome-sudoku" "Sudoku" "Sudoku game" \
        "TRUE" "gnome-todo" "Todo" "Todo list" \
        "TRUE" "transmission-gtk" "Transmission" "BitTorrent client" \
        "TRUE" "rhythmbox" "Rhythmbox" "Music player" \
        "TRUE" "shotwell" "Shotwell" "Photo management" \
        "TRUE" "thunderbird" "Thunderbird" "Mail client" \
        "TRUE" "totem" "Totem" "Video player" \
    ))
    sudo apt -y remove "${packages[@]}"
    sudo apt -y auto-remove
}

installEssential() {
    textColor 3 'Install: Essential'
    sudo apt -y install git htop inxi aria2 curl iputils-ping vim jq

    sudo update-alternatives --set editor /usr/bin/vim.basic

    packages=($(yad --on-top --width=600 --height=400 --title="Install Essential" \
        --list --checklist --multiple --separator=" " \
        --column=" " --column="Action" --column="Application" --column="Description" \
        --search-column=3 --hide-column=2 --print-column=2 \
        "TRUE" "cifs-utils nfs-common sshfs" "File system tools" "Tools for SSH, Samba and NFS" \
        "TRUE" "ncdu" "NCurses Disk Usage" "Disk usage" \
        "TRUE" "exa" "Exa" "Prettier list filesystem" \
        "TRUE" "duf" "Duf" "Disk Usage Utility" \
        "TRUE" "testdisk extundelete" "Recover files" "Packages: testdisk, extundelete" \
        "TRUE" "p7zip-full p7zip-rar" "7-Zip" "Compression tools (+7-Zip-Rar)" \
        "TRUE" "rar unrar-free" "Rar" "Compression tools" \
        "TRUE" "diffutils" "Diff Utils" "Compare files" \
        "TRUE" "conky-all" "Conky" "Desktop tools" \
        "TRUE" "gparted" "GParted" "Partition Editor" \
        "FALSE" "openssh-server" "OpenSSH Server" "Server for Secure Shell" \
        "FALSE" "whois" "Whois" "Client for directory service" \
    ))
    sudo apt -y install "${packages[@]}"
}

installFlatpak() {
    textColor 3 'Install: Flatpak'
    sudo apt -y install flatpak
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    # Restart system: reboot
}

installWine() {
    textColor 3 'Install: Wine'
    sudo apt -y install wine winbind

    winecfg &
    yad --on-top --width=400 --title "Configure Wine" --button="gtk-ok:0" --text "\
Application > Windows-Version = Windows 10\
"
}

installPlayOnLinux() {
    textColor 3 'Install: Play on Linux'
    sudo apt -y install playonlinux
}

installDocker() {
    textColor 3 'Install: Docker'
    sudo apt -y install docker.io

    # Only if your want run it for another user than root
    selectedUsername=$(getUsername)
    if [[ "${selectedUsername}" == "" ]]; then
        textColor 1 "Error: Username not selected!"
        exit 1;
    fi
    sudo usermod -aG docker ${selectedUsername}
}

installDockerCompose() {
    textColor 3 'Install: Docker Compose'
    local usernameRepository='docker/compose'
    VERSION=$(getGithubReleaseLatest "${usernameRepository}")
    curl -o /tmp/docker-compose -fsSL "https://github.com/${usernameRepository}/releases/download/v${VERSION}/docker-compose-$(uname -s)-$(uname -m)"
    sudo install /tmp/docker-compose /usr/local/bin/docker-compose
}

# Software #####################################################################
installFirefox() {
    textColor 3 'Install: Firefox'
    sudo snap install firefox
}

installThunderbird() {
    textColor 3 'Install: Thunderbird'
    sudo apt -y install thunderbird
}

installLibreOffice() {
    textColor 3 'Install: LibreOffice'
    sudo add-apt-repository -y ppa:libreoffice/ppa
    sudo apt -y install libreoffice libreoffice-base
}

installPdfArranger() {
    textColor 3 'Install: PDF Arranger'
    sudo apt -y install pdfarranger
}

installFluentReader() {
    textColor 3 'Install: Fluent Reader'
    local usernameRepository='yang991178/fluent-reader'
    VERSION=$(getGithubReleaseLatest "${usernameRepository}")

    curl -o /tmp/fluent-reader.AppImage -fsSL "https://github.com/${usernameRepository}/releases/download/v${VERSION}/Fluent.Reader.${VERSION}.AppImage"
    sudo install /tmp/fluent-reader.AppImage /usr/local/bin/fluent-reader.AppImage

    if [ ! -d /usr/local/share/icons ]; then
        sudo mkdir -p /usr/local/share/icons
    fi
    sudo curl -o /usr/local/share/icons/fluent-reader.png -fsSL "https://raw.githubusercontent.com/${usernameRepository}/master/build/icon.png"

    cat <<EOF | sudo tee /usr/share/applications/fluent-reader.desktop
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

installYacReader() {
    textColor 3 'Install: YACReader'
    echo 'deb http://download.opensuse.org/repositories/home:/selmf/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:selmf.list
    curl -fsSL https://download.opensuse.org/repositories/home:selmf/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_selmf.gpg > /dev/null
    sudo apt update
    sudo apt -y install yacreader
}

installDiscord() {
    textColor 3 'Install: Discord'
    curl -o /tmp/discord.deb -fsSL "https://discord.com/api/download?platform=linux&format=deb"
    # @bug Installation failed because packages missing
    set +e
    sudo dpkg -i /tmp/discord.deb
    set -e
    sudo apt -y -f install
}

installDiscord() {
    textColor 3 'Install: Discord'
    curl -o /tmp/discord.deb -fsSL "https://discord.com/api/download?platform=linux&format=deb"
    # @bug Installation failed because packages missing
    set +e
    sudo dpkg -i /tmp/discord.deb
    set -e
    sudo apt -y -f install
}

installThreema() {
    textColor 3 'Install: Threema'
    curl -o /tmp/threema.deb -fsSL "https://releases.threema.ch/web-electron/v1/release/Threema-Latest.deb"
    sudo dpkg -i /tmp/threema.deb
}

installSignal() {
    textColor 3 'Install: Signal'
    # sudo snap install signal-desktop
    curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee /etc/apt/sources.list.d/signal-desktop.list
    sudo apt update
    sudo apt -y install signal-desktop
}

installTelegram() {
    textColor 3 'Install: Telegram'
    # @bug Problems with file permissions
    #sudo snap install telegram-desktop
    curl -o /tmp/telegram.tar.xz -fsSL "https://telegram.org/dl/desktop/linux"
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

installElement() {
    textColor 3 'Install: Element'
    sudo apt -y install wget apt-transport-https

    sudo curl -o /usr/share/keyrings/element-io-archive-keyring.gpg -fsSL "https://packages.element.io/debian/element-io-archive-keyring.gpg"
    echo 'deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main' | sudo tee /etc/apt/sources.list.d/element.list
    sudo apt update
    sudo apt -y install element-desktop
}

installLinphone() {
    textColor 3 'Install: Linphone'
    VERSION='4.4.1'

    sudo curl -o /tmp/Linphone.AppImage -fsSL "https://www.linphone.org/releases/linux/app/Linphone-${VERSION}.AppImage"
    sudo install /tmp/Linphone.AppImage /usr/local/bin/Linphone.AppImage

    if [ ! -d /usr/local/share/icons ]; then
        sudo mkdir -p /usr/local/share/icons
    fi
    sudo curl -o /usr/local/share/icons/linphone.png -fsSL "https://github.com/BelledonneCommunications/linphone-desktop/raw/master/linphone-app/assets/icons/hicolor/64x64/apps/icon.png"

    cat <<EOF | sudo tee /usr/share/applications/Linphone.desktop
[Desktop Entry]
Name=Linphone
Comment=Linphone is an open source SIP phone for voice/video calls and instant messaging.
Exec="/usr/local/bin/Linphone.AppImage"
Terminal=false
Type=Application
#Icon=/usr/share/icons/Yaru/scalable/actions/call-start-symbolic.svg
Icon=/usr/local/share/icons/linphone.png
StartupWMClass=linphone
Categories=Utility;
TryExec=/usr/local/bin/Linphone.AppImage
EOF
}

installSpotify() {
    textColor 3 'Install: Spotify'
    sudo snap install spotify
}

installAudacity() {
    textColor 3 'Install: Audacity'
    sudo apt -y install audacity
}

installFreac() {
    textColor 3 'Install: fre:ac'
    sudo snap install freac
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
    flatpak install -y flathub com.github.rafostar.Clapper
}

installKodi() {
    textColor 3 'Install: Kodi (XBMC)'
    sudo apt -y install kodi
}

installHandbrake() {
    textColor 3 'Install: Handbrake'
    sudo apt -y install handbrake
}

installKdenlive() {
    textColor 3 'Install: Kdenlive'
    sudo add-apt-repository -y ppa:kdenlive/kdenlive-stable
    sudo apt -y install kdenlive
}

installFlowblade() {
    textColor 3 'Install: Flowblade'
    sudo apt -y install libmlt-data
    sudo apt -y install flowblade
}

installOpenShot() {
    textColor 3 'Install: OpenShot'
    local usernameRepository='OpenShot/openshot-qt'
    VERSION=$(getGithubReleaseLatest "${usernameRepository}")

    curl -o /tmp/OpenShot.AppImage -fsSL "https://github.com/${usernameRepository}/releases/download/v${VERSION}/OpenShot-v${VERSION}-x86_64.AppImage"
    sudo install /tmp/OpenShot.AppImage /usr/local/bin/OpenShot.AppImage

    if [ ! -d /usr/local/share/icons ]; then
        sudo mkdir -p /usr/local/share/icons
    fi
    sudo curl -o /usr/local/share/icons/openshot.svg -fsSL "https://raw.githubusercontent.com/${usernameRepository}/master/images/openshot.svg"

    cat <<EOF | sudo tee /usr/share/applications/OpenShot.desktop
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

installMkvToolNix() {
    textColor 3 'Install: MkvToolNix'

    # Optional: Updates
    sudo curl -o /usr/share/keyrings/gpg-pub-moritzbunkus.gpg -fsSL "https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg"
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/ubuntu/ $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/mkvtoolnix.list
    echo "deb-src [arch=amd64 signed-by=/usr/share/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/ubuntu/ $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/mkvtoolnix.list
    sudo apt update

    sudo apt -y install mkvtoolnix mkvtoolnix-gui
}

installGwenview() {
    textColor 3 'Install: Gwenview'
    sudo apt -y install gwenview
}

installXnview() {
    textColor 3 'Install: Xnview'

    curl -o /tmp/XnViewMP.deb -fsSL "https://download.xnview.com/XnViewMP-linux-x64.deb"
    # Fix missing
    sudo apt -y install libgdk-pixbuf2.0-0 libxcb-xinerama0
    sudo dpkg -i /tmp/XnViewMP.deb

    xnview &
    yad --on-top --width=400 --title "Configure XnView" --button="gtk-ok:0" --text "Run XnView, initialize config file and close it!"

    if [ -f ~/.config/xnviewmp/xnview.ini ]; then
        sudo apt -y install crudini

        # Ask close XnView
        crudini --set ~/.config/xnviewmp/xnview.ini '%General' showAgain 65536

        # Thumbnail
        crudini --set ~/.config/xnviewmp/xnview.ini 'Appearance' overlayIcons 63743
        crudini --set ~/.config/xnviewmp/xnview.ini 'Appearance' thumbLabels "1 2 7 "

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

installInkscape() {
    textColor 3 'Install: Inkscape'
    sudo apt -y install inkscape
}

installCzkawka() {
    textColor 3 'Install: Czkawka'
    local usernameRepository='qarmin/czkawka'
    VERSION=$(getGithubReleaseLatest "${usernameRepository}")
    curl -o /tmp/czkawka-gui -fsSL "https://github.com/${usernameRepository}/releases/download/${VERSION}/linux_czkawka_gui"
    sudo install /tmp/czkawka-gui /usr/local/bin/czkawka-gui
}

installFlameshot() {
    textColor 3 'Install: Flameshot'
    sudo apt -y install flameshot
}

installVokoScreen() {
    textColor 3 'Install: VokoScreen'
    sudo apt -y install vokoscreen
}

installObsStudio() {
    textColor 3 'Install: Obs Studio'

    # Optional
    sudo add-apt-repository -y ppa:obsproject/obs-studio
    sudo apt update

    sudo apt -y install obs-studio v4l2loopback-dkms ffmpeg
}

installPeek() {
    textColor 3 'Install: Peek'
    sudo apt -y install peek
}

installVideoTools() {
    textColor 3 'Install: Video tools'
    sudo apt -y install ffmpeg
}

# https://www.unifiedremote.com/
# http://localhost:9510/web/
installUnifiedRemote() {
    textColor 3 'Install: Unified Remote'
    curl -o /tmp/unifiedremote.deb -fsSL "https://www.unifiedremote.com/download/linux-x64-deb"
    sudo dpkg -i /tmp/unifiedremote.deb
}

installRustDesk() {
    textColor 3 'Install: RustDesk'
    local usernameRepository='rustdesk/rustdesk'
    VERSION=$(getGithubReleaseLatest "${usernameRepository}")
    curl -o /tmp/rustdesk.deb -fsSL "https://github.com/${usernameRepository}/releases/download/${VERSION}/rustdesk-${VERSION}.deb"
    # Fix missing packages
    sudo apt -y install libxdo3
    sudo dpkg -i /tmp/rustdesk.deb
}

installTeamViewer() {
    textColor 3 'Install: TeamViewer'
    # @bug: Key is stored in deprecated trusted.gpg keychain
    curl -o /tmp/teamviewer.deb -fsSL "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
    # Fix missing packages
    sudo apt -y install libminizip1
    sudo dpkg -i /tmp/teamviewer.deb
    # @bug Installation failed because packages missing
    sudo apt -f install

    # @fixme: Key is stored in deprecated trusted.gpg keychain
    sudo apt-key export 8CAE012EBFAC38B17A937CD8C5E224500C1289C0 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/teamviewer -2017.gpg
    sudo apt-key export D2A5FEB3488160F028CC17918DA84BE5DEB49217 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/teamviewer.gpg
}

installAnyDesk() {
    textColor 3 'Install: AnyDesk'

    # @fixme: Key is stored in deprecated trusted.gpg keychain
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/anydesk.gpg

    # @bug: Key is stored in deprecated trusted.gpg keychain
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
    echo "deb http://deb.anydesk.com/ all main" | sudo tee -a /etc/apt/sources.list.d/anydesk-stable.list
    sudo apt update
    # Fix missing packages
    sudo apt -y install libminizip1
    # @bug Installation failed because packages missing
    sudo apt -y install anydesk
}

installNoMachine() {
    textColor 3 'Install: NoMachine'
    # NoMachine Linux 64bit - https://www.nomachine.com/download/download&id=4
    NOMACHINE_VERSION="7.9.2_1"
    NOMACHINE_MD5="a24aa0b09543d207034e8198972cbd24"
    NOMACHINE_OS="Linux" && NOMACHINE_ARCHITECTURE="amd64"
    NOMACHINE_VERSION_SHORT=`echo ${NOMACHINE_VERSION} | cut -d. -f1-2`
    curl -o /tmp/nomachine.deb -fsSL "https://download.nomachine.com/download/${NOMACHINE_VERSION_SHORT}/${NOMACHINE_OS}/nomachine_${NOMACHINE_VERSION}_${NOMACHINE_ARCHITECTURE}.deb"

    if ! echo "${NOMACHINE_MD5} /tmp/nomachine.deb" | md5sum -c -; then
        yad --on-top --image="gtk-dialog-error" --width=400 --title "NoMachine" --button="gtk-close:1" --text "Error installing NoMachine!\nMD5 checksum not match!"
    else
        sudo dpkg -i /tmp/nomachine.deb
    fi
}

installBalenaEtcher() {
    textColor 3 'Install: Balena Etcher'
    local usernameRepository='balena-io/etcher'
    VERSION=$(getGithubReleaseLatest "${usernameRepository}")

    curl -o /tmp/etcher.deb -fsSL "https://github.com/${usernameRepository}/releases/download/v${VERSION}/balena-etcher-electron_${VERSION}_amd64.deb"
    # Fix
    sudo apt -y install gconf2 gconf-service libgconf-2-4 libgdk-pixbuf2.0-0
    sudo dpkg -i /tmp/etcher.deb

    # @fixme: Key is stored in deprecated trusted.gpg keychain
    sudo apt-key export 8F40D32ABF59D635B11612F270528471AFF9A051 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/balena-etcher.gpg
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

installSteam() {
    textColor 3 'Install: Steam'
    sudo apt -y install steam
}

installSyncthing() {
    textColor 3 'Install: Syncthing'
    sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg -fsSL "https://syncthing.net/release-key.gpg"
    echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
    sudo apt update
    sudo apt install syncthing

    if [ ! -d ~/.config/autostart ]; then
        mkdir -p ~/.config/autostart
    fi
    if [ ! -d ~/.local/share/applications ]; then
        mkdir -p ~/.local/share/applications
    fi
    curl -o ~/.config/autostart/syncthing-start.desktop -fsSL "https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-desktop/syncthing-start.desktop"
    curl -o ~/.local/share/applications/syncthing-ui.desktop -fsSL "https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-desktop/syncthing-ui.desktop"
}

installNextcloudDesktop() {
    textColor 3 'Install: Nextcloud Desktop'
    local usernameRepository='nextcloud/desktop'
    VERSION=$(getGithubReleaseLatest "${usernameRepository}")

    curl -o /tmp/nextcloud.AppImage -fsSL "https://github.com/${usernameRepository}/releases/download/v${VERSION}/Nextcloud-${VERSION}-x86_64.AppImage"
    sudo install /tmp/nextcloud.AppImage /usr/local/bin/nextcloud.AppImage
    #yad --on-top --width=400 --title "Configure Wine" --button="gtk-ok:0" --text "Run XnView, initialize config file and close it!"

    if [ ! -d /usr/local/share/icons ]; then
        sudo mkdir -p /usr/local/share/icons
    fi
    sudo curl -o /usr/local/share/icons/nextcloud.svg -fsSL "https://raw.githubusercontent.com/${usernameRepository}/master/theme/colored/Nextcloud-icon.svg"

    cat <<EOF | sudo tee /usr/share/applications/nextcloud.desktop
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

installDropbox() {
    textColor 3 'Install: Dropbox'
    # @bug: Key is stored in deprecated trusted.gpg keychain
    curl -o /tmp/dropbox.deb -fsSL "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb"
    sudo apt -y install libpango1.0-0 python3-gpg
    sudo dpkg -i /tmp/dropbox.deb
}

installRestic() {
    textColor 3 'Install: Restic'
    sudo apt -y install restic
    sudo restic self-update
}

installRdiffBackup() {
    textColor 3 'Install: RdiffBackup'
    sudo apt -y install rdiff-backup
}

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

installVisualStudioCode() {
    textColor 3 'Install: Visual Studio Code'
    sudo snap install code --classic
}

installAtom() {
    textColor 3 'Install: Atom'
    sudo apt -y install wget

    # @bug Crashed!
    wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
    echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" | sudo tee /etc/apt/sources.list.d/atom.list
    sudo apt-get update
    sudo apt -y install atom
}

installPhpStorm() {
    textColor 3 'Install: PhpStorm'
    sudo snap install phpstorm --classic
}

installMeld() {
    textColor 3 'Install: Meld'
    sudo apt -y install meld
}

installJqYqXq() {
    textColor 3 'Install: Jq, Yq, Xq (Json/Yaml/Xml processor)'
    sudo apt -y install jq python3 python3-pip
    sudo pip3 install yq
}

installGo() {
    textColor 3 'Install: Go-Lang'
    sudo snap install go --classic
}

installFileZilla() {
    textColor 3 'Install: FileZilla'
    sudo apt -y install filezilla
}

installHeidiSql() {
    textColor 3 'Install: HeidiSQL'
    VERSION='12.0.0.6468'

    if [ ! -d ~/Dokumente/HeidiSQL ]; then
        mkdir -p ~/Dokumente/HeidiSQL
    fi
    if [ -d ~/Dokumente/HeidiSQL/../../Sync/notes/Programming/SQL ] && [ ! -d ~/Dokumente/HeidiSQL/Snippets ]; then
        ln -s ../../Sync/notes/Programming/SQL ~/Dokumente/HeidiSQL/Snippets
    fi

    curl -o /tmp/heidisql.exe -fsSL "https://www.heidisql.com/installers/HeidiSQL_${VERSION}_Setup.exe"
    wine /tmp/heidisql.exe
}

installPutty() {
    textColor 3 'Install: PuTTY'
    curl -o /tmp/putty.zip -fsSL "https://the.earth.li/~sgtatham/putty/latest/w64/putty.zip"
    mkdir -p ~/.wine/drive_c/Program\ Files\ \(x86\)/PuTTY
    unzip /tmp/putty.zip -d ~/.wine/drive_c/Program\ Files\ \(x86\)/PuTTY
}

installVirtualBox() {
    textColor 3 'Install: VirtualBox'
    echo 'virtualbox-ext-pack virtualbox-ext-pack/license select true' | sudo debconf-set-selections
    sudo apt -y install virtualbox virtualbox-ext-pack
    sudo systemctl disable vboxweb.service
}

# Installation #################################################################
installDependencies() {
    selectedList=($(yad --on-top --width=600 --height=300 --title="Install Dependencies" \
        --list --checklist --multiple --separator=" " \
        --column=" " --column="Action" --column="Application" --column="Description" \
        --search-column=3 --hide-column=2 --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
        "TRUE" "installFlatpak" "Flatpak" "Package manager" \
        "TRUE" "installWine" "Wine" "Run Windows applications" \
        "TRUE" "installPlayOnLinux" "PlayOnLinux" "Create multiple Wine prefixes" \
        "TRUE" "installDocker" "Docker" "Container Virtualisation" \
        "TRUE" "installDockerCompose" "Docker Compose" "Container Virtualisation" \
        "TRUE" "reboot" "Reboot" "Reboot System" \
    ))
    for selected in "${selectedList[@]}"; do
        ${selected}
    done
}

installSoftware() {
    set +e
    yad --on-top --image="gtk-dialog-warning" --width=300 --title "Preselect Software" \
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

    selectedList=($(yad --window-icon="gtk-ok" --on-top --width=600 --height=600 --title="Install Software" \
        --list --checklist --multiple --separator=" " \
        --column=" " --column="Action" --column="Application" --column="Description" \
        --search-column=3 --hide-column=2 --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
        "${TICK:-FALSE}" "installFirefox" "Firefox" "Webbrowser" \
        "${TICK:-FALSE}" "installThunderbird" "Thunderbird" "Mail client" \
        "${TICK:-FALSE}" "installLibreOffice" "LibreOffice" "Office Suite" \
        "${TICK:-FALSE}" "installPdfArranger" "PDF Arranger" "PDF Arranger" \
        "${TICK:-FALSE}" "installFluentReader" "Fluent Reader" "RSS Reader" \
        "${TICK:-FALSE}" "installCalibre" "Calibre" "EBook Reader (epub)" \
        "${TICK:-FALSE}" "installYacReader" "YACReader" "Comic Book Reader (cbz, cbr)" \
        "${TICK:-FALSE}" "installDiscord" "Discord" "Instant messaging, Chat, Voice conferencing" \
        "${TICK:-FALSE}" "installThreema" "Threema" "Instant messaging, Voice conferencing" \
        "${TICK:-FALSE}" "installSignal" "Signal" "Instant messaging, Voice conferencing" \
        "${TICK:-FALSE}" "installTelegram" "Telegram" "Instant messaging, Voice conferencing" \
        "${TICK:-FALSE}" "installSlack" "Slack" "Instant messaging, Voice conferencing" \
        "${TICK:-FALSE}" "installSkype" "Skype" "Instant messaging, Voice conferencing" \
        "${TICK:-FALSE}" "installElement" "Element" "Instant messaging" \
        "${TICK:-FALSE}" "installLinphone" "Linphone" "Voice conferencing" \
        "${TICK:-FALSE}" "installSpotify" "Spotify" "Audio streaming" \
        "${TICK:-FALSE}" "installAudacity" "Audacity" "Audio editor" \
        "${TICK:-FALSE}" "installFreac" "fre:ac" "Audio converter and CD ripper" \
        "${TICK:-TRUE}" "installVlc" "VLC (Video Lan Client)" "Video player" \
        "${TICK:-TRUE}" "installMpv" "mpv" "Video player" \
        "${TICK:-TRUE}" "installClapper" "Clapper" "Video player" \
        "${TICK:-FALSE}" "installKodi" "Kodi (XBMC)" "Media center" \
        "${TICK:-FALSE}" "installHandbrake" "Handbrake" "Video transcoder" \
        "${TICK:-FALSE}" "installKdenlive" "Kdenlive" "Video editor" \
        "${TICK:-FALSE}" "installFlowblade" "Flowblade" "Video editor" \
        "${TICK:-FALSE}" "installOpenShot" "OpenShot" "Video editor" \
        "${TICK:-FALSE}" "installPitivi" "Pitivi" "Video editor" \
        "${TICK:-FALSE}" "installVideoEffects" "Video effects" "Video effects" \
        "${TICK:-FALSE}" "installMkvToolNix" "MkvToolNix" "Matroska media container tools" \
        "${TICK:-FALSE}" "installGwenview" "Gwenview" "Image viewer" \
        "${TICK:-TRUE}" "installXnview" "Xnview" "Image viewer" \
        "${TICK:-FALSE}" "installGimp" "Gimp" "Image editor" \
        "${TICK:-FALSE}" "installInkscape" "Inkscape" "Vector image editor" \
        "${TICK:-FALSE}" "installCzkawka" "Czkawka" "Duplicate image finder" \
        "${TICK:-FALSE}" "installFlameshot" "Flameshot" "Screenshot tools" \
        "${TICK:-FALSE}" "installVokoScreen" "VokoScreen" "Screen recorder" \
        "${TICK:-FALSE}" "installObsStudio" "ObsStudio" "Screen recorder" \
        "${TICK:-FALSE}" "installPeek" "Peek" "Screen recorder" \
        "${TICK:-FALSE}" "installVideoTools" "Video tools" "ffmpeg" \
        "${TICK:-FALSE}" "installUnifiedRemote" "Unified Remote" "Remote control" \
        "${TICK:-FALSE}" "installRustDesk" "RustDesk" "Remote maintenance" \
        "${TICK:-FALSE}" "installTeamViewer" "TeamViewer" "Remote maintenance" \
        "${TICK:-FALSE}" "installAnyDesk" "AnyDesk" "Remote maintenance" \
        "${TICK:-FALSE}" "installNoMachine" "NoMachine" "Remote maintenance" \
        "${TICK:-FALSE}" "installBalenaEtcher" "Balena Etcher" "USB burning tool" \
        "${TICK:-FALSE}" "installK3b" "K3b" "Disc burning tool" \
        "${TICK:-FALSE}" "installXfburn" "Xfburn" "Disc burning tool" \
        "${TICK:-FALSE}" "installBrasero" "Brasero" "Disc burning tool" \
        "${TICK:-FALSE}" "installSteam" "Steam" "Game client" \
        "${TICK:-FALSE}" "installSyncthing" "Syncthing" "Sycronisation tool" \
        "${TICK:-FALSE}" "installNextcloudDesktop" "Nextcloud Desktop" "Sycronisation tool" \
        "${TICK:-FALSE}" "installDropbox" "Dropbox" "Sycronisation tool" \
        "${TICK:-TRUE}" "installRestic" "Restic" "Backup tool" \
        "${TICK:-TRUE}" "installRdiffBackup" "RdiffBackup" "Backup tool" \
        "${TICK:-TRUE}" "installCroc" "Croc" "File transfer tool" \
        "${TICK:-TRUE}" "installAria2" "Aria2" "File download tool" \
        "${TICK:-FALSE}" "installDeluge" "Deluge" "BitTorrent client" \
        "${TICK:-FALSE}" "installVisualStudioCode" "Visual Studio Code" "Editor, IDE (Integrated Development Environment)" \
        "${TICK:-FALSE}" "installAtom" "Atom" "Editor, IDE (Integrated Development Environment)" \
        "${TICK:-FALSE}" "installPhpStorm" "PhpStorm" "Editor, IDE (Integrated Development Environment)" \
        "${TICK:-FALSE}" "installMeld" "Meld" "Visual diff and merge tool" \
        "${TICK:-TRUE}" "installJqYqXq" "Jq, Yq, Xq" "Json/Yaml/Xml processor" \
        "${TICK:-FALSE}" "installGo" "Go-Lang" "Go language" \
        "${TICK:-FALSE}" "installFileZilla" "FileZilla" "FTP/SFTP Client" \
        "${TICK:-FALSE}" "installHeidiSql" "HeidiSQL" "FTP/SFTP Client" \
        "${TICK:-FALSE}" "installPutty" "PuTTY" "PuTTY utilities" \
        "${TICK:-FALSE}" "installVirtualBox" "VirtualBox" "Virtual machines" \
    ))
    for selected in "${selectedList[@]}"; do
        ${selected}
    done
}

updateSoftware() {
    selectedList=($(yad --window-icon="gtk-ok" --on-top --width=600 --height=600 --title="Update Software" \
        --list --checklist --multiple --separator=" " \
        --column=" " --column="Action" --column="Application" --column="Description" \
        --search-column=3 --hide-column=2 --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
        "FALSE" "installCroc" "Croc" "File transfer tool" \
        "FALSE" "installCzkawka" "Czkawka" "Duplicate image finder" \
        "FALSE" "installDiscord" "Discord" "Instant messaging, Chat, Voice conferencing" \
        "FALSE" "installFluentReader" "Fluent Reader" "RSS Reader" \
        "FALSE" "installHeidiSql" "HeidiSQL" "FTP/SFTP Client" \
        "FALSE" "installLinphone" "Linphone" "Voice conferencing" \
        "FALSE" "installNextcloudDesktop" "Nextcloud Desktop" "Sycronisation tool" \
        "FALSE" "installOpenShot" "OpenShot" "Video editor" \
        "FALSE" "installPutty" "PuTTY" "PuTTY utilities" \
        "FALSE" "installRustDesk" "RustDesk" "Remote maintenance" \
        "FALSE" "installUnifiedRemote" "Unified Remote" "Remote control" \
        "FALSE" "installXnview" "Xnview" "Image viewer" \
        "FALSE" "installYacReader" "YACReader" "Comic Book Reader (cbz, cbr)" \
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

# Besser fragen, was gestartet werden soll
checkYadInstalled
prepareSystem

selectedList=($(yad --window-icon="gtk-ok" --on-top --width=350 --height=250 --title="Installation Process" \
    --list --checklist --multiple --separator=" " \
    --column=" " --column="Action" --column="Application" \
    --search-column=3 --hide-column=2 --print-column=2 --button=gtk-cancel:1 --button=gtk-ok:0 \
    "${TICK:-FALSE}" "configureEnergy" "Configure Energy" \
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
    #yad --on-top --image="gtk-dialog-info" --width=400 --title "Prepare System" \
    #    --button="gtk-close:1" --button="gtk-ok:0" --text "Prepare System?"
    #if [ $? -eq 0 ]; then
 #       configureEnergy
 #       prepareSystem
    #fi

  #  installEssential
  #  installDependencies

   # touch /tmp/ubuntu-installation.lock
#fi

#installSoftware

gnomeControlCenter() {
    gnome-control-center datetime
    gnome-control-center default-apps
    gnome-control-center keyboard
    gnome-control-center location
    gnome-control-center lock
    gnome-control-center mouse
    gnome-control-center multitasking
    gnome-control-center printers
    gnome-control-center removable-media
    gnome-control-center search
    gnome-control-center sharing
    gnome-control-center sound
    gnome-control-center ubuntu
    gnome-control-center usage
    gnome-control-center user-accounts
}

textColor 2 "# Script success"
