# QR-Code

Install and generate:

```bash
sudo apt install qrencode

qrencode -o qrcode.png -l H "{TEXT}"
qrencode -o qrcode.png -s 4 -l H "{TEXT}"
```

## QR-Code texts

Wifi:

```text
WIFI:T:WPA;S:{SSID};P:{Password};;
```

VCard:

```text
MECARD:N:lastname,firstname;TEL:+49-1234-56789;EMAIL:email@example.org;URL:http://example.org/;NICKNAME:User;BDAY:19841128;NOTE:{Notes};TEL-AV:Videophone:Telnumber;ADR:Gardenstr. 123, Place, 71234 Germany;;

MECARD:N:lastname,firstname;TEL:+49-1234-56789;EMAIL:email@example.org;URL:http://example.org/;NICKNAME:User;BDAY:19841128;NOTE:{Notes};TEL-AV:Videophone:Telnumber;ADR:Gardenstr. 123, room-number, 123, Place, District, 71234 Germany;;
```

Phone:

```text
TEL:+49 123456789
```

URL:

```text
http://example.org.de
```

SMS:

```text
SMSTO:{49123456789}:{Text}
```
