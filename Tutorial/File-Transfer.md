# File Transfer

Sometimes you just want to send a file quickly and securely.

The most popular tools so far:

* [Wormhole](https://wormhole.app/)
* [Croc](https://github.com/schollz/croc)
* [Magic Wormhole](https://magic-wormhole.readthedocs.io/en/latest/)
* [PairDrop](https://pairdrop.net/)

## With shareable link

These are Firefox Send forked projects or similar projects.

* [Wormhole](https://wormhole.app/)

Firefox send forks:

* [timvisee: Send instances](https://github.com/timvisee/send-instances/#instances)
* Send files via...
  * [vis.ee](https://send.vis.ee/)
  * [zcyph](https://send.zcyph.cc/)
  * [mni.li](https://send.mni.li/)
  * [ggc-project.de](https://fileupload.ggc-project.de/)
  * [adminforge.de](https://send.adminforge.de/)
  * [turingpoint.de](https://send.turingpoint.de/)

Similar projects:

* [Internxt Send](https://send.internxt.com/)
* [0up](https://0up.io/)
* [Sharrr](https://www.sharrr.com/)

Website worth mentioning but not necessarily recommended.

* [WeTransfer](https://wetransfer.com/)
* [Dropbox Transfer](https://www.dropbox.com/transfer/)
* [Send Anywhere](https://send-anywhere.com/)

## Like Apple Airdrop (WebRTC)

* [PairDrop](https://pairdrop.net/)
* [Blaze](https://blaze.vercel.app/app)
* [ShareDrop](https://www.sharedrop.io/)

## Croc

* [Croc](https://github.com/schollz/croc)
* [Croc: Own notes](../Software/Croc.md)

```bash
# Install Linux
curl https://getcroc.schollz.com | bash

# Install Windows
scoop install croc
#choco install croc

# Send
croc send <file/directory>
croc --local send <file/directory>

# Receive
croc <code>
```

## Only same network

Magic Wormhole:

* [Magic Wormhole](https://magic-wormhole.readthedocs.io/en/latest/)
* [Warpinator](https://github.com/linuxmint/warpinator)
  * [Warpinator: Android](https://github.com/slowscript/warpinator-android)
  * [Warpinator: Windows](https://github.com/slowscript/warpinator-windows)

* [Rymdport](https://flathub.org/apps/details/io.github.jacalz.rymdport)
* [RiftShare](https://flathub.org/apps/details/app.riftshare.RiftShare)
* [Warp](https://flathub.org/apps/details/app.drey.Warp)

* [Wormhole William](https://github.com/psanford/wormhole-william)
* [Wormhole William Mobile](https://github.com/psanford/wormhole-william-mobile)
* [Android: Wormhole William](https://play.google.com/store/apps/details?id=io.sanford.wormhole_william)

```bash
# Install Linux
sudo apt install magic-wormhole
sudo snap install wormhole

# Install Linux GUI
flatpak install flathub io.github.jacalz.rymdport
flatpak install flathub app.riftshare.RiftShare
flatpak install flathub app.drey.Warp

# Install Windows
scoop install magic-wormhole
choco install magic-wormhole
scoop install wormhole-william

# Usage
wormhole send <file/directory>
wormhole receive <code>

wormhole-william send <file/directory>
wormhole-william receive <code>
```

LocalSend:

* [LocalSend](https://localsend.org/)

## Services

Open source:

* [Syncthing](https://syncthing.net/)
* [Nextcloud](https://nextcloud.com/)
* [ownCloud](https://owncloud.com/)

Closed source:

* [Google Drive](https://drive.google.com/)
* [Dropbox](https://www.dropbox.com/)
* [Microsoft OneDrive](https://onedrive.live.com/)
* [Mega.io/Mega.nz](https://mega.io/)

## Messegner

Most chats can also send files, but this is not strictly recommended.

* [WhatsApp](https://whatsapp.com/)
* [Telegram](https://telegram.org/)
* [Threema](https://threema.ch/)
* [Signal](https://signal.org/)

## Own server

* [timvisee/send](https://gitlab.com/timvisee/send)
  * [timvisee/send-docker-compose](https://github.com/timvisee/send-docker-compose)
  * [mozilla/send](https://github.com/mozilla/send)
* [Gokapi](https://github.com/Forceu/Gokapi)
