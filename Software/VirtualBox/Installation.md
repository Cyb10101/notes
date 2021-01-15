# VirtualBox: Installation

[VirtualBox](https://www.virtualbox.org/)

## VirtualBox installation

From Ubuntu repository:

```bash
sudo apt install virtualbox virtualbox-ext-pack
sudo systemctl disable vboxweb.service
```

From Oracle repository:

```bash
# Remove old packages
sudo apt remove virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-qt

wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

sudo apt update
sudo apt install virtualbox-6.1

# Install extension pack via download from virtualbox (full file path required)
aria2c --download-result=hide --dir=/tmp -o Oracle_VM_VirtualBox_Extension_Pack-6.1.16.vbox-extpack https://download.virtualbox.org/virtualbox/6.1.16/Oracle_VM_VirtualBox_Extension_Pack-6.1.16.vbox-extpack
sudo vboxmanage extpack install /tmp/Oracle_VM_VirtualBox_Extension_Pack-6.1.16.vbox-extpack
```
