# Convert Google Contacts to FritzBox contacts

**Requirements and import sequence:**

* Export [Google contacts](https://contacts.google.com/) as "Google CSV"
* Convert CSV to JSON via [csv2json](../csv2json/Readme.md): `csv2json contacts.csv`
* Convert JSON to XML via this binary: `contacts-google2fritzbox contacts.json`
* Import XML to [Fritz!Box Router](http://192.168.178.1/)

For lazy people: `csv2json contacts.csv && contacts-google2fritzbox contacts.json`

## Execute

Test in development:

```bash
go run contacts-google2fritzbox.go contacts.json fritzbox-contacts.xml
```

Compile and move to binary folder:

```bash
# Linux
sudo go build -o /usr/local/bin/contacts-google2fritzbox

# Windows
env GOOS=windows GOARCH=amd64 go build
```

Execute:

```bash
# Convert contacts.json to export.json
contacts-google2fritzbox contacts.json

# Convert contacts.json to fritzbox-contacts.xml
contacts-google2fritzbox contacts.json fritzbox-contacts.xml
```
