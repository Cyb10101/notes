# Hardware: Printer / Scanner

* [OpenPrinting CUPS (http)](http://localhost:631)
* [OpenPrinting CUPS (https)](https://localhost:631)

## Offset Calculation

* 1 Inch = 25,4 mm
* **Move 1 mm to right:**
  1/(25,4/300) = 1 Point / (25,4 mm / 300 DPI) = 11,8 Points = 12 Points
* **Move 1 mm to left:**
  -1/(25,4/300) = -1 Point / (25,4 mm / 300 DPI) = -11,8 Points = -12 Points

## Brother DCP-L3560CDW

*Last installed: 2025*

* [Store](https://store.brother.de/catalogs/brothergermany/geraete/laser/dcp/dcpl3560cdw)
  * [Consumables](https://www.brother.de/verbrauchsmaterial/dcpl3560cdw)
    * Normal Toner
      * [TN-248BK](https://store.brother.de/catalogs/brothergermany/verbrauchsmaterial/laser/toner/tn/tn248bk)
      * [TN-248C](https://store.brother.de/catalogs/brothergermany/verbrauchsmaterial/laser/toner/tn/tn248c)
      * [TN-248M](https://store.brother.de/catalogs/brothergermany/verbrauchsmaterial/laser/toner/tn/tn248m)
      * [TN-248Y](https://store.brother.de/de-de/catalogs/brothergermany/verbrauchsmaterial/laser/toner/tn/tn248y)
    * XL Toner
    * [TN-248XLC](https://store.brother.de/catalogs/brothergermany/verbrauchsmaterial/laser/toner/tn/tn248xlc)
    * [TN-248XLM](https://store.brother.de/catalogs/brothergermany/verbrauchsmaterial/laser/toner/tn/tn248xlm)
    * [TN-248XLY](https://store.brother.de/catalogs/brothergermany/verbrauchsmaterial/laser/toner/tn/tn248xly)
* [Support](https://support.brother.com/g/b/downloadtop.aspx?c=de&lang=de&prod=dcpl3560cdw_us_eu_as)
* [Download Driver](https://www.brother.de/support/dcpl3560cdw/downloads)
* [Printer Web Interface](http://192.168.178.19/)

Printer:

```bash
# Find printer
LANG=C lpinfo -E -l -v | grep -E 'uri|info|make-and-model'

# Add printer
lpadmin -p Brother_DCP-L3560CDW_IPP -E -v ipps://Brother%20DCP-L3560CDW%20series._ipps._tcp.local/ -m everywhere

# Set default printer
lpadmin -d Brother_DCP-L3560CDW_IPP
```

Scanner:

```bash
# Scanner driver 64bit (deb package) - This is the Scanner driver
sudo dpkg -i brscan5-1.4.0-3.amd64.deb

# Find scanners in network
brsaneconfig5 -q

# Add and remove scanner (Just do it, because something would be configured)
sudo brsaneconfig5 -a name=Brother-DCP-L3560CDW model=DCP-L3560CDW ip=192.168.178.19

# Remove scanner
sudo brsaneconfig5 -r 'Brother-DCP-L3560CDW'

# If missing in Ubuntu
sudo apt -y install simple-scan
```

## Brother DCP-L3550CDW

*Last installed: 2024*

* [Download Driver](https://www.brother.de/support/dcpl3550cdw/downloads)

Printer:

```bash
# Find printer
LANG=C lpinfo -E -l -v | grep -E 'uri|info|make-and-model'

# Add printer
lpadmin -p Brother_DCP-L3550CDW_IPP -E -v ipp://BRW4CD577252854:631/ipp -m everywhere

# Set default printer
lpadmin -d Brother_DCP-L3550CDW_IPP
```

Scanner:

```bash
# Scanner driver 64bit (deb package) - This is the Scanner driver
sudo dpkg -i brscan4-0.4.11-1.amd64.deb

# Find scanners in network
brsaneconfig4 -q

# Add and remove scanner (Just do it, because something would be configured)
sudo brsaneconfig4 -a name=Brother-DCP-L3550CDW model=DCP-L3550CDW ip=192.168.178.30

# If missing in Ubuntu
sudo apt -y install simple-scan
```

## Brother DCP-9022CDW

*Destroyed*

* [Download Driver](https://www.brother.de/support/dcp-9022cdw/downloads)
* [Printer Web Interface](http://192.168.178.27/)

Without installing drivers (Recommend):

* Get node name: [Printer Web Interface > Network](http://192.168.178.27/net/net/net.html)

```bash
# Find printer
LANG=C lpinfo -E -l -v | grep -E 'uri|info|make-and-model'

lpadmin -p Brother_DCP-L3550CDW_IPP -E -v ipp://BRW4CD577252854:631/ipp -m everywhere
lpadmin -d Brother_DCP-L3550CDW_IPP

# Add printer
lpadmin -p Brother_DCP-9022CDW_IPP -E -v ipp://BRWACD1B84ED6B9:631/ipp -m everywhere

# Set default printer
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
# Scanner driver 64bit (deb package) - This is the Scanner driver
sudo dpkg -i brscan4-0.4.11-1.amd64.deb

# Find scanners in network
brsaneconfig4 -q

# Add and remove scanner (Just do it, because something would be configured)
sudo brsaneconfig4 -a name=Brother-DCP-9022CDW model=DCP-9022CDW ip=192.168.178.27

# If missing in Ubuntu
sudo apt -y install simple-scan
```

A scan over the WSD protocol might not work properly (DPI).

## Get total count of printed pages

Only from local computer (questionable):

```bash
lpstat -a
printerCompleted=$(lpstat -W completed | grep 'Printer name' | wc -l)
```

From a printer Webpage:

```bash
sudo apt -y install libxml2-utils

echo 'cat //*[@id="pageContents"]//*[@class="contentsGroup"]//dt[text()="Page Counter"]/following-sibling::dd[1]/text()' | xmllint --html --shell <(curl -fsSL 'http://192.168.178.21/general/information.html?kind=item') | sed '/^\/ >/d' | sed 's/<[^>]*.//g'
```
