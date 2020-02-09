# Hardware: Printer / Scanner

## Brother DCP-9022CDW

[Download Driver](http://support.brother.com/g/b/downloadlist.aspx?c=eu_ot&lang=en&prod=dcp9022cdw_eu&os=128)

### Install Printer

```bash
sudo dpkg -i dcp9022cdwlpr-1.1.3-0.i386.deb
sudo dpkg -i dcp9022cdwcupswrapper-1.1.4-0.i386.deb
```

http://localhost:631/admin

### Install Scanner

```bash
sudo dpkg -i brscan4-0.4.4-1.amd64.deb
sudo dpkg -i brscan-skey-0.2.4-1.amd64.deb
sudo dpkg -i brother-udev-rule-type1-1.0.0-1.all.deb

brsaneconfig4 -a name=Brother model=DCP-9022CDW ip=192.168.178.27
```

## Brother-DCP-J715W

```bash
sudo lpinfo --make-and-model 'ip4500' -m
sudo lpadmin -p 'Brother-DCP-J715W' -m Brother/brother_dcpj715w_printer_en.ppd -v socket://192.168.178.27 -E
sudo lpadmin -d 'Brother-DCP-J715W'
```

### Install Printer

```bash
# Brother DCP-J715W CUPS
dnssd://Brother%20DCP-J715W._pdl-datastream._tcp.local/
```
### Install Scanner

Add `brother3` in `/etc/sane.d/dll.conf`.

Run scan-key-tool (The program will run as a background process.)

```bash
brscan-skey
```

Not required: Add `brother4` in `/etc/sane.d/dll.conf`.
