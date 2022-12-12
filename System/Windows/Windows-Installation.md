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

## Package Manager: Scoop

*Note: Only english installations, if not handled in Software.*

* [Scoop: Website](https://scoop.sh)
* [Scoop: Github](https://github.com/lukesampson/scoop)
* [Scoop: Buckets](https://github.com/lukesampson/scoop#known-application-buckets)

Run `powershell` as user.

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

scoop install aria2 7zip git croc restic sudo
scoop bucket add extras
scoop install mpv ffmpeg

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
