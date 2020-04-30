# Hardware: Printer / Scanner

## Brother DCP-9022CDW

* [Download Driver](https://www.brother.de/support/dcp-9022cdw/downloads)
* [Printer Web Interface](https://192.168.178.27/)

### Without installing drivers

Recommend:

```bash
lpadmin -p Brother_DCP-9022CDW_IPP -E -v ipp://BRWACD1B84ED6B9:631/ipp -m everywhere
lpadmin -d Brother_DCP-9022CDW_IPP
```

### Alternate driver

Install with GUI: Gutenberg - Brother DCP-9010CN BR-Script3

```bash
# Find printer driver
lpinfo --make-and-model 'DCP-9010' -m
# -> Brother DCP-9010CN BR-Script3

# List devices
lpinfo -E -l -v
# -> lpd://BRWACD1B84ED6B9/BINARY_P1
```

### Install company drivers

Not working:

```bash
# Bug: dcp9022cdwlpr/opt/brother/Printers/dcp9022cdw/inf/setupPrintcapij:35
# Solve: mkdir -p $SPOOLER_NAME
mkdir -p /var/spool/lpd/dcp9022cdw

sudo dpkg -i dcp9022cdwlpr-1.1.3-0.i386.deb
sudo dpkg -i dcp9022cdwcupswrapper-1.1.4-0.i386.deb

lpadmin -p DCP9022CDW-LPD -E -v lpd://BRWACD1B84ED6B9/BINARY_P1 -P /usr/share/cups/model/Brother/brother_dcp9022cdw_printer_en.ppd
```

### Install scanner

```bash
sudo dpkg -i brscan4-0.4.8-1.amd64.deb
sudo dpkg -i brscan-skey-0.2.4-1.amd64.deb
sudo dpkg -i brother-udev-rule-type1-1.0.2-0.all.deb

sudo brsaneconfig4 -a name=Brother model=DCP-9022CDW ip=192.168.178.27
```
