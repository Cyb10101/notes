# File Transfer

Sometimes you just want to send a file quickly and securely.

Useful tools are:

* [Wormhole](https://wormhole.app/)
* [Croc](https://github.com/schollz/croc)
* [Magic Wormhole](https://magic-wormhole.readthedocs.io/en/latest/)

Others are either questionable or have a more specific use case.

## Wormhole (Firefox Send)

These are Firefox Send forked projects.

* [Wormhole](https://wormhole.app/)

* [timvisee: Send files via send.vis.ee](https://send.vis.ee/)
* [timvisee: Send instances](https://github.com/timvisee/send-instances/#instances)
* [Git: timvisee/send](https://gitlab.com/timvisee/send)
* [Git: timvisee/send-docker-compose](https://github.com/timvisee/send-docker-compose)
* [Git: mozilla/send](https://github.com/mozilla/send)

## Croc

* [Croc](https://github.com/schollz/croc)

```bash
# Install Linux
curl https://getcroc.schollz.com | bash

# Install Windows
scoop install croc
#choco install croc

# Send
croc send [FILE/DIRECTORY]

# Receive
croc [CODE]
```

## Magic Wormhole

* [Magic Wormhole](https://magic-wormhole.readthedocs.io/en/latest/)

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
wormhole send [FILE/DIRECTORY]
wormhole receive [CODE]

wormhole-william send [FILE/DIRECTORY]
wormhole-william receive [CODE]
```

## Websites

Website worth mentioning but not necessarily recommended.

* [WeTransfer](https://wetransfer.com/)
* [Dropbox Transfer](https://www.dropbox.com/transfer/)
* [Send Anywhere](https://send-anywhere.com/)
* [ShareDrop](https://www.sharedrop.io/)

## Services

Open source:

* [Syncthing](https://syncthing.net/)
* [Nextcloud](https://nextcloud.com/)
* [ownCloud](https://owncloud.com/)

Closed source:

* [Google Drive](https://drive.google.com/)
* [Dropbox](https://www.dropbox.com/)
* [Microsoft OneDrive](https://onedrive.live.com/)

## Messegner

Most chats can also send files, but this is not strictly recommended.

* [WhatsApp](https://whatsapp.com/)
* [Telegram](https://telegram.org/)
* [Threema](https://threema.ch/)
* [Signal](https://signal.org/)
