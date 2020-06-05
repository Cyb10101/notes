# VirtualBox: Installation

[VirtualBox](https://www.virtualbox.org/)

## VirtualBox installation

From Ubuntu repository:

```bash
sudo apt install virtualbox virtualbox-ext-pack
sudo systemctl disable vboxweb.service
```

From Docker repository:

```bash
wget -qO - https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bionic contrib" > /etc/apt/sources.list.d/virtualbox.list'
sudo apt update
sudo apt install virtualbox-6.1
```

```bash
aria2c --download-result=hide --dir=/tmp -o VirtualBox.vbox-extpack https://download.virtualbox.org/virtualbox/6.1.6/Oracle_VM_VirtualBox_Extension_Pack-6.1.6.vbox-extpack
```
