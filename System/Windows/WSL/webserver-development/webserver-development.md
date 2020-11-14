# Development Webserver

Create a development Webserver.

## Docker Global

```bash
wsl

mkdir ~/projects

git clone https://github.com/Cyb10101/docker-global.git ~/projects/global
cd ~/projects/global

sudo mkdir -p .docker/global-nginx-proxy/certs
sudo openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
    -keyout .docker/global-nginx-proxy/certs/default.key \
    -out .docker/global-nginx-proxy/certs/default.crt

./start.sh start
```

## DNS

Just edit `C:\Windows\System32\drivers\etc\hosts`:

```text
127.0.0.1 portainer.localhost mail.localhost
127.0.0.1 website.localhost
```

## DNS (Acrylic)

Doesn't work because port 53 is occupied by Windows!

Start > Settings > Network and Internet > Ethernet > Change adapter options
Either 127.0.0.1 or 172.17.192.1

```text
127.0.0.1 /.*\.vmd$
172.17.192.1 /.*\.vmd$
```
