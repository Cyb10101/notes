# Windows Installation

* [Firefox](https://www.mozilla.org/de/firefox/new/)

```powershell
# PowerShell Version
$PSVersionTable
```

Update Windows (run as user):

```powershell
start ms-windows-store://updates; control update
scoop status; scoop update; scoop update --all
sudo Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit choco outdated; sudo choco upgrade all"
```

## BitLocker encryption

Disable BitLocker encryption (run as administrator):

```powershell
$BLV = Get-BitLockerVolume
Disable-BitLocker -MountPoint $BLV
```

## Package Manager: Scoop

*Note: Only english installations, if not handled in Software.*

* [Scoop: Website](https://scoop.sh)
* [Scoop: Github](https://github.com/lukesampson/scoop)
* [Scoop: Buckets](https://github.com/lukesampson/scoop#known-application-buckets)

Run `powershell` as user.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Recommended
scoop install aria2 7zip git sudo
scoop config aria2-warning-enabled false

# Standard bucket (Without other buckets)
scoop install croc
scoop install gpg
scoop install restic
scoop install yt-dlp ffmpeg

# Bucket: Extas
scoop bucket add extras
scoop install mpv ffmpeg

# Other
scoop list
scoop status; scoop update; scoop update --all
```

* Run 7-zip as administrator > Tools > Options
  - Tab "System" > Associate for user = 7z, zip, rar
  - Tab "7-Zip" > Integrate 7-Zip to shell context menu = true

## Package Manager: Chocolatey

Multilingual installation.

* [Chocolatey](https://chocolatey.org/)
* [Chocolatey: Packages](https://chocolatey.org/packages)

Run `powershell` as administrator.

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation
```

Close powershell and run `choco` in `cmd` or `powershell` as administrator.

```shell
choco list --localonly
choco outdated && choco upgrade all
```

## Package Manager: WinGet

Preinstalled on Windows 11 22H2.

* [WinGet: Store](https://www.microsoft.com/de-de/p/app-installer/9nblggh4nns1) (Recommended)
* [WinGet: Github](https://github.com/microsoft/winget-cli)
* [WinGet Packages Manifests](https://github.com/microsoft/winget-pkgs/tree/master/manifests)

Commands:

```shell
winget upgrade
winget upgrade --all

winget search firefox
winget install --exact --id=Mozilla.Firefox
```

Search multiple applications:

```shell
$apps = @(
  "firefox",
  "thunderbird"
)
foreach ($id in $apps) {
  Write-Output "## Website: $($id)"
  winget search $id
  Write-Output ""
}
```

Combine name, website and id for quick installation:

```shell
$apps = @(
  "Mozilla.Firefox",      # Fuck
  "Mozilla.Thunderbird"   # Me
)
foreach ($id in $apps) {
  Write-Output "-> Website: $($id)"
  #Write-Output "$(winget show --exact --id=$id | Select-String -Pattern '^Startseite:.*$')"
  #Write-Output ""
  echo "# $($(winget show --exact --id=$id | Select-String -Pattern '^Gefunden.*$')) ($(winget show --exact --id=$id | Select-String -Pattern '^Startseite:.*$'))" >> list.txt
  echo "`"$($id)`"," >> list.txt
}
```

Install multiple applications:

```shell
$apps = @(
  "JetBrains.PHPStorm",                 # PhpStorm (https://www.jetbrains.com/phpstorm)
  "Meld.Meld",                          # Meld (http://meldmerge.org/)
  # Error: "jqlang.jq",                 # jq (https://github.com/jqlang/jq)
  "GoLang.Go",                          # Go Programming Language (https://go.dev)
  "HeidiSQL.HeidiSQL",                  # HeidiSQL (https://www.heidisql.com/)
  "PuTTY.PuTTY",                        # PuTTY (https://putty.org)
  "Oracle.VirtualBox",                  # Oracle VM VirtualBox (https://www.virtualbox.org)
  "Docker.DockerDesktop",               # Docker Desktop (https://www.docker.com/products/docker-desktop)
  "Mozilla.Firefox",                    # Mozilla Firefox (https://www.mozilla.org/de/firefox/)
  "Mozilla.Thunderbird",                # Mozilla Thunderbird (https://www.thunderbird.net/de/)
  "TheDocumentFoundation.LibreOffice",  # LibreOffice (https://www.libreoffice.org/)
  "PDFArranger.PDFArranger",            # PDFArranger (https://github.com/pdfarranger/pdfarranger)
  "yang991178.fluent-reader",           # Fluent Reader (https://github.com/yang991178/fluent-reader)
  "calibre.calibre",                    # Calibre (https://calibre-ebook.com)
  "YACReader.YACReader",                # YACReader (https://www.yacreader.com)
  # Error Hash: "Threema.Threema",      # Threema (https://threema.ch/download)
  "OpenWhisperSystems.Signal",          # Signal (https://www.signal.org)
  "Telegram.TelegramDesktop",           # Telegram Desktop (https://desktop.telegram.org)
  "SlackTechnologies.Slack",            # Slack (https://slack.com)
  "Microsoft.Skype",                    # Skype (https://www.skype.com/)
  "Element.Element",                    # Element (https://element.io)
  "Zoom.Zoom",                          # Zoom (https://zoom.us/)
  "BelledonneCommunications.Linphone",  # Linphone (https://linphone.org/)
  # Error: "Spotify.Spotify",           # Spotify (https://www.spotify.com/download/windows/)
  "Audacity.Audacity",                  # Audacity (https://www.audacityteam.org/)
  "AppWork.JDownloader",                # JDownloader 2 (https://jdownloader.org/)
  "VideoLAN.VLC",                       # VLC media player (https://www.videolan.org/vlc/)
  "XBMCFoundation.Kodi",                # Kodi (https://kodi.tv)
  "HandBrake.HandBrake",                # HandBrake (https://handbrake.fr)
  # Error installer hangs: "OpenShot.OpenShot", # OpenShot Video Editor (https://github.com/OpenShot/openshot-qt)
  "MoritzBunkus.MKVToolNix",            # MKVToolNix (https://mkvtoolnix.download/)
  "XnSoft.XnViewMP",                    # XnViewMP (https://www.xnview.com/en/xnviewmp/)
  "GIMP.GIMP",                          # GIMP (https://www.gimp.org)
  "Inkscape.Inkscape",                  # Inkscape (https://inkscape.org/)
  "Flameshot.Flameshot",                # Flameshot (https://flameshot.org)
  "OBSProject.OBSStudio",               # OBS Studio (https://obsproject.com/)
  "RustDesk.RustDesk",                  # RustDesk (https://rustdesk.com/)
  "TeamViewer.TeamViewer",              # TeamViewer (https://www.teamviewer.com/de/)
  # Error Hash: "AnyDeskSoftwareGmbH.AnyDesk", # AnyDesk (https://anydesk.com)
  "NoMachine.NoMachine",                # NoMachine (https://nomachine.com/)
  "Balena.Etcher",                      # balenaEtcher (https://www.balena.io/etcher)
  "Valve.Steam",                        # Steam (https://store.steampowered.com)
  # Error: "Syncthing.Syncthing",       # Syncthing (https://github.com/syncthing/syncthing)
  "Nextcloud.NextcloudDesktop",         # Nextcloud (https://nextcloud.com)
  "Dropbox.Dropbox",                    # Dropbox (https://www.dropbox.com)
  # Error: "restic.restic",             # Restic (https://github.com/restic/restic)
  "Microsoft.VisualStudioCode",         # Visual Studio Code (https://code.visualstudio.com)
  "VSCodium.VSCodium",                  # VSCodium (https://vscodium.com)
  "DelugeTeam.Deluge",                  # Deluge BitTorrent Client (https://deluge-torrent.org)
  "aria2.aria2",                        # Aria2 (https://aria2.github.io/)
  "schollz.croc",                       # Croc (https://github.com/schollz/croc)
  "Bitwarden.Bitwarden",                # Bitwarden (https://bitwarden.com/download)
  "KeePassXCTeam.KeePassXC",            # KeePassXC (https://keepassxc.org)
  "Google.Chrome",                      # Google Chrome (https://www.google.com/intl/en_us/chrome)
  "JAMSoftware.TreeSize.Free",          # TreeSize Free (https://www.jam-software.com/treesize_free/)
  "WinDirStat.WinDirStat",              # WinDirStat (https://windirstat.net)
  "TeamSpeakSystems.TeamSpeakClient",   # TeamSpeak 3 Client (https://www.teamspeak.com/en/)
  "DominikReichl.KeePass",              # KeePass (https://keepass.info)
  "DOSBox.DOSBox",                      # DOSBox (https://www.dosbox.com/)
  "Overwolf.CurseForge",                # CurseForge (https://curseforge.overwolf.com/)
  "WinSCP.WinSCP",                      # WinSCP (https://winscp.net)
  "NickeManarin.ScreenToGif",           # ScreenToGif (https://www.screentogif.com)
  "Greenshot.Greenshot",                # Greenshot (https://getgreenshot.org)
  "Skillbrains.Lightshot",              # Lightshot (https://app.prntscr.com/en/)
  "KDE.Kdenlive",                       # Kdenlive (https://kdenlive.org/en)
  "7zip.7zip",                          # 7-Zip (https://www.7-zip.org)
  "RARLab.WinRAR",                      # WinRAR (https://www.win-rar.com/start.html?&L=1)
  # Error: "Rufus.Rufus",               # Rufus (https://rufus.ie)
  "LIGHTNINGUK.ImgBurn",                # ImgBurn (https://www.imgburn.com/)
  "VaclavSlavik.Poedit",                # Poedit (https://poedit.net)
  # Error Hash: "WhatsApp.WhatsApp",    # WhatsApp (https://www.whatsapp.com)
  "ItchIo.Itch",                        # itch (https://itch.io/app)
  "Amazon.Games",                       # Amazon Games (https://gaming.amazon.com/home)
  # Error Hash: "ElectronicArts.EADesktop", # EA app (https://www.ea.com/ea-desktop-beta)
  # Error Hash: "Ubisoft.Connect",      # Ubisoft Connect (https://ubisoftconnect.com)
  "EpicGames.EpicGamesLauncher",        # Epic Games Launcher (https://www.epicgames.com)
  "PDFsam.PDFsam",                      # PDFsam Basic (http://www.pdfsam.org)
  "Mp3tag.Mp3tag",                      # Mp3tag (https://www.mp3tag.de/en/index.html)
  "Microsoft.Teams",                    # Microsoft Teams (https://www.microsoft.com/en-us/microsoft-teams/group-chat-software)
  "ShareX.ShareX",                      # ShareX (https://getsharex.com)
  "Microsoft.WindowsTerminal",          # Windows Terminal (https://docs.microsoft.com/windows/terminal)
  "voidtools.Everything",               # Everything (https://www.voidtools.com)
  "angryziber.AngryIPScanner",          # Angry IP Scanner (https://angryip.org/)
  "Lexikos.AutoHotkey",                 # AutoHotkey 1 (https://autohotkey.com)
  "AutoHotkey.AutoHotkey",              # AutoHotkey 2 (https://www.autohotkey.com/)
  "Discord.Discord"                     # Discord (https://discord.com)
)
foreach ($id in $apps) {
  Write-Output "-> Install: $($id)"
  winget install --exact --id=$id
  Write-Output ""
}
```

## Windows 11 Configuration

@todo German language

* Explorer > Go to Downloads
* Anzeigen = Details
* Sortieren = Name
* Sortieren > Group by = (none)
* Options
  * Tab "Allgemein" > Datenschutz
    * Zuletzt verwendete Ordner anzeigen = false
    * Häufig verwendete Ordner anzeigen = false
    * Dateien von Office.com anzeigen = false
  * Tab "Ansicht" > Erweiterte Einstellungen
    * Erweiterungen bei bekannten Dateitypen ausblenden = false
  * Übernehmen
  * Ordneransicht > Für alle Ordner übernehmen

* Einstellungen > System > Multitasking > Fenster andocken > Andocklayouts anzeigen, wenn ich ein Fenster an den oberen Bildschirmrand ziehe = false
* Einstellungen > Personalisierung > Hintergrund
  * Hintergrund personalisieren = Diashow
    * Ein Bildalbumd für eine Diashow auswählen = %USERPROFILE%\Sync\Pictures\background
    * Bildänderungsintervall = 1 hour
    * Die Bilder unsortiert anzeigen = true
    * Wählen Sie das Passende für Ihr Desktopbild aus = Anpassen
* Einstellungen > Personalisierung > Farben
  * Modus auswählen = Benutzerdenifiert
  * Standardmäßigen Windows-Modus auswählen = Dunkel
  * Standard-App-Modus auswählen = Hell
* Einstellungen > Personalisierung > Sperrbildschirm
  * Ihren Sperrbildschirm personalisieren = Bild
    * Album für Bildschirmpräsentation hinzufügen = %USERPROFILE%\Sync\Pictures\background -> Windows Linux Penguin MSN 1920x1080.jpg
    * Unterhaltung, Tipps, Tricks und mehr auf dem Sperrbildschirm anzeigen = false
  * Erweiterte Diashoweinstellungen
  * Status des Sperrbildschirmes = Keiner
* Einstellungen > Personalisierung > Start
  * Layout = Mehr angeheftete Elemente
  * Zuletzt hinzugefügte Apps anzeigen = false
  * Ordner = Einstellungen, Persönlicher Ordner
* Einstellungen > Personalisierung > Taskleiste
  * Taskleistenelemente
    * Suche = false
    * Widget = false
    * Chat = false
  * Andere Taskleistensymbole
    * App??? = true
  * Verhalten der Taskleiste
    * Taskleistenausrichtung = left

* Systemsteuerung > Hardware und Sound > Sound > Tab "Kommunikation" > Beim Erkennen von Kommunikationsaktivitäten = Nichts unternehmen

## Software installation

* [Visual Studio Code](../../Software/Visual-Studio-Code.md)
* [Syncthing](../../Software/Syncthing.md)
* [Sandbox](Sandbox/Sandbox.wsb)

@todo German language
* [Telegram Desktop](https://desktop.telegram.org/)
  * Einstellungen > Language = Deutsch
  * Einstellungen > Chat-Einstellungen > Hintergrundbild = Last (Sternenhimmel)
  * Einstellungen > Erweitert > Einbindung in das System > Systemfenster verwenden = true
  * Einstellungen > Erweitert > Einbindung in das System > Telegram beim Systemstart ausführen = true
  * Einstellungen > Erweitert > Einbindung in das System > Minimiert starten = true
* [Discord](https://discord.com/)
  * Einstellungen > Sprach- & Videochat > Mikrofonempfindlichkeit = -50dB
  * Einstellungen > Windows-Einstellungen > System-Startverhalten > Minimiert starten = true
  * Einstellungen > Windows-Einstellungen > Schliessen-Schaltfläche > In Symbolleiste minimieren = false
  * Einstellungen > Streamer-Modus > Streamer-Modus aktivieren = false
  * Einstellungen > Aktivitätseinstellungen > Game-Overlay > In-Game-Overlay aktivieren = false

* [Steam](https://store.steampowered.com/)
  * Einstellungen > Im Spiel
    * Overlay-Tastenkombination = F12
    * Screenshots-Tastenkombination = F9
    * Screenshot Ordner = C:\Users\Username\Desktop
    * FPS-Anzeige im Spiel = Unten links
    * Beim Aufnehmen eines Screenshots > Unkomprimierte Kopie speichern = true
  * Einstellungen > Oberfläche
    * ...Fenster beim Programstart... = Bibliothek
    * Steam starten, wenn mein Computer gestartet wird = false
  * Einstellungen > Downloads
    * Downloadbeschränkungen > Downloads während des Spielens zulassen = true
  * Einstellungen > Übertragungen = deaktiviert
* [Epic Games](https://store.epicgames.com/)
  * Einstellungen > Einstellungen
    * Minimiren und im Infobereich anzeigen = false
    * Beim Hochfahren starten = false
  * Einstellungen > Desktop-Benachrichtigungen
    * Zu kostenlosen Spielen benachrichtigen = false
    * Neuigkeiten und Benachrichtigungen für Sonderangebote anzeigen = false
* [Blizzard Battle.net](https://www.blizzard.com/apps/battle.net/desktop)
  * Einstellungen > App > Start > Battle.net beim Starten des Computers starten = false
  * Einstellungen > Downlads > Netzwerkbandbreite > Downloadbandbreite beschränken = false
  * Einstellungen > Freune & Chat > Chat > Schimpfwortfilter auf Chat anwenden = false
  * Einstellungen > Voicechat > Mikrofon > Übertragungsmodus = Push-to-Talk
* [EA (Electronic Arts)](https://www.ea.com/de-de/ea-app)
* [Amazon Games](https://www.amazongames.com/de-de/support/prime-gaming/articles/download-and-install-the-amazon-games-app)
* [Ubisoft Connect](https://ubisoftconnect.com/)
  * Einstellungen > Allgemein > Benachrichtigungen zu bevorstehenden Veröffentlichungen zu meinem Spiel aktivieren = false
  * Einstellungen > Allgemein > ...im Systembereich der Taskleiste minimieren... = false
  * Einstellungen > Allgemein > Start anzeige = Spiele
* [GOG - Good old Games](https://www.gog.com/)
  * Einstellungen > GOG Galaxy-Client > Allgemein > Komfort > Automatischer Start = false
  * Einstellungen > GOG.com-Spiele > Installieren/aktualisieren > Bandbreite > Während des Spiels = false
* [Itch Client](https://itch.io/app)
  * Einstellungen > Verhalten > Anwendung weiter im Infobereich anzeigen, wenn das Fenster geschlossen wird = false

* [TeamViewer](https://www.teamviewer.com/)
  * C:\Users\cyb10\AppData\Local\TeamViewer
  * C:\Users\cyb10\AppData\Roaming\TeamViewer
  * Einstellungen > Fernsteuerung > Anzeige > Bildschirmhintergrund entfernen = true
  * Einstellungen > Fernsteuerung > Anzeige > Mauszeiger des Partners darstellen = false
  * Einstellungen > Fernsteuerung > Fernsteuerungsvoreinstellungen > Computersounds und Musik abspielen = false
  * Einstellungen > Fernsteuerung > Fernsteuerungsvoreinstellungen > Tastenkombinationen übertragen = true
  * Einstellungen > Erweitert > Erweiterte Einstellungen für Verbindungen zu diesem Computer
    * Zugriffskontrolle = Alles Bestätigen
* [AnyDesk](https://anydesk.com/)
  * Einstellungen > Sicherheit > Sicherheitseinstellungen freigeben
    * Sicherheit > Berechtigungen > Standard
      * Tastatur und Maus verwenden = true
        * meinen Computer neustarten = false
        * Strg + Alt + Entf = false
      * die Zwischenablage verwenden = true
        * ...um Dateien zu übertragen = false
      * den Datei-Manager verwenden = false
* [NoMachine](https://www.nomachine.com/)
* [RustDesk](https://github.com/rustdesk/rustdesk/releases/latest)
* [Parsec](https://parsec.app/)
  * Tray Icon > Run when my computer starts = false

* MPV
  * Open with: C:\Users\cyb10\scoop\apps\mpv\current\mpv.exe

* [XnView MP](https://www.xnview.com/de/xnviewmp/#downloads)
  * C:\Users\cyb10\AppData\Roaming\XnViewMP

* [iStripper](https://www.istripper.com/)
  * %USERPROFILE%\AppData\Local\vghd
  * Einstellungen > Erweiterte Einstellungen
  * Desktop > Maximaleanzahl Girls = 2
  * Desktop > Aktive Sammlungen = Virtuaguy
  * Vollbildmodus > Name des Models anzeigen = Nur beim 1. Mal
  * Sicherer Arbeitsplatz > iStripper beim Hochfahren starten = false
  * Sicherer Arbeitsplatz > Deaktiviert starten = true
  * Lautstärkeregelung > iStripper startet = false
  * Lautstärkeregelung > Shows starten (an/aus) = false
  * Lautstärkeregelung > Desktop-Clips = 40%
  * Lautstärkeregelung > Desktop-Musik = 15%
  * Lautstärkeregelung > Clips im Vollbild = 40%
  * Lautstärkeregelung > Musik im Vollbild = 15%
  * Lautstärkeregelung > Sound im Mini-Modus = false
* Xbox > Einstellungen > Allgemein > Starteinstellungen > App im Hintergrund weiter ausführen = false
* [Spotify](https://spotify.com/)
  * Einstellungen > Audioqualität > Streamingqualität = Sehr hoch
  * Einstellungen > Audioqualität > Herunterladen = Sehr hoch
  * Einstellungen > Audioqualität > Standardlautstärke = false
  * Einstellungen > Anzeige > Ankündigungen zu Neuerscheinungen anzeigen = false
  * Einstellungen > Anzeige > Sehen, was deine Freunde hören = false
  * Einstellungen > Spotify App beim Start des Rechners öffnen > Spotify automatisch beim Anmelden öffnen = Nein
* AMD Software > Einstellungen
  * System > Snapshot
  * Hotkeys > Hotkeys verwenden = false
  * Einstellungen > Allgemein > In-Game-Overlay = false

## Bugfix Scoop

```shell
cd %USERPROFILE%\scoop\buckets\extras
git fetch && git reset --hard origin/master
```

* [Software installation](../../Software/Software-Installation.md)
