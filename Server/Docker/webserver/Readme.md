# Docker: Webserver

@todo add fail2ban to ssh docker
@todo add nginx html pages

Example structure of a Webserver:

* global: Nginx reverse proxy
* mail: Mail System + Roundmail website
* user_cyb10101: Shares SSH & Composer data, SSH/SFTP Server
* website_www: Website only

## Change SSH Port

```bash
sudo vim /etc/ssh/sshd_config
```

```text
Port 2200
ListenAddress 0.0.0.0
ListenAddress ::
```

```bash
sudo systemctl restart ssh
ssh user@server.com -p2200
```

## Motd (Message of the day)

Disable last ssh login with `PrintLastLog no`:

```bash
vim /etc/ssh/sshd_config
sudo systemctl restart ssh
```

Disable motd's (Message of the day):

```bash
chmod -x /etc/update-motd.d/00-header
chmod -x /etc/update-motd.d/10-help-text
chmod -x /etc/update-motd.d/50-landscape-sysinfo
chmod -x /etc/update-motd.d/50-motd-news
chmod -x /etc/update-motd.d/80-livepatch
```

## Fail2Ban

```bash
sudo apt install fail2ban
sudo vim /etc/fail2ban/jail.d/jail.local
```

```text
[DEFAULT]
ignoreip = 127.0.0.1/8 your_server_ip
#mta = mail
destemail = user@example.org
#sendername = Fail2BanAlerts
maxretry = 3
findtime = 600
bantime = 600
```

```bash
sudo service fail2ban restart
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

## Docker

* [Docker Installation](../Installation.md)

## Server: DNS

```bash
A: 123.3.2.1 (Your server IPv4)
MX: mail.example.org
TXT: v=spf1 a mx ip4:123.3.2.1 ~all
```

## Server: Reverse DNS

Generic names (Domain) are bad: host123456789.example.org

### Reverse DNS: Configure

* Strato Server-Login > Domains > DNS-Reverse > FQDN (Fully Qualified Domain Name) = server.com
* Netcup Server-Login > Choose Server > Network > IPv4 (rDNS) = server.com

* German: Plesk > Tools & Einstellungen > Servereinstellungen > Vollständiger Hostname = server.com

### Reverse DNS: Set Hostname

```bash
hostnamectl set-hostname server.com
vim /etc/hosts
```

```text
127.0.1.1	server.com
```

### Reverse DNS: Test

Get domain or ip from MX entry:

```bash
dig +noall +answer server.com MX
# server.com.  3600  IN  MX  10 mail.server.com.
```

Get ip from mail domain:

```bash
dig +noall +answer mail.server.com A
# mail.server.com.  3600  IN  A  123.3.2.1
```

Get reverse dns (PTR) from IP:

```bash
dig +noall +answer -x 123.3.2.1
# 1.2.3.123.in-addr.arpa. 1800 IN	PTR	server.com.
```

Check PTR from arpa:

```bash
dig +short 1.2.3.123.in-addr.arpa PTR
# server.com.
```

Test Mail Server if PTR & HELO is the same:

```bash
telnet smtp.server.com 25
# 220 server.com ESMTP
HELO example.org
# 250 server.com
QUIT
```

## Server: Open ports

Sometimes it seems necessary that Docker has an IPv4 so that it is available on the network.
Or maybe the wrong network is selected.

```bash
docker ps
docker-compose ps
```

If only that is displayed `25/tcp, 0.0.0.0:110->110/tcp`, then port 25 is only internal and must be set globally.
The result is: `0.0.0.0:25->25/tcp, 0.0.0.0:110->110/tcp`

Example of the `docker-compose.yml` file:

```yaml
ports:
  - "0.0.0.0:25:25"
  - 110:110
```

Check with nmap:

```bash
sudo apt install nmap
nmap localhost
nmap server.com
```

## Server: date & time

The date and time of the server should always be correct.

```bash
# Activate or force synchronization now
timedatectl set-ntp 0
timedatectl set-ntp 1

# Status
timedatectl status
```

## Let's Encrypt

Force certificates renewal, if needed:

```bash
~/projects/global/start.sh exec global-letsencrypt /app/force_renew
```

## Git

Add server deploy key:

```bash
ssh-keygen -t rsa -b 4096 -C 'production-servername'
```

## Web: Default certificate

Generate a standard certificate for websites. This will replace Let's Encrypt later.

Execute in `global` Container.

```bash
sudo mkdir -p ~/projects/global/.docker/global-nginx-proxy/certs
sudo openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
    -keyout ~/projects/global/.docker/global-nginx-proxy/certs/default.key \
    -out ~/projects/global/.docker/global-nginx-proxy/certs/default.crt
```

## Web: User permissions

Always think for user permissions, especially when content is connected to Docker!

```bash
chown -R 1000:1000 .
```

**Security note:** If you connect other instances with same volumes, for example a global read only SSH key or a Composer cache directory, other users can have access to private content. If you really need it, it is safer to store it in your own instance.

## MySQL / MariaDB

```bash
~/projects/global/start.sh mysql
```

Create database and user:

```sql
CREATE DATABASE `website_www`;
CREATE USER 'username'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON `website_www`.* TO 'username'@'%';
FLUSH PRIVILEGES;
```

Change password:

```sql
ALTER USER 'username'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
```

Remove database and user:

```sql
SELECT User, Host FROM mysql.user;
DROP USER 'username'@'%';
SHOW GRANTS FOR 'username'@'%';
FLUSH PRIVILEGES;
```

## Mail

* [tomav/docker-mailserver](https://github.com/tomav/docker-mailserver)

The `setup.sh` file is started outside of the Docker container.

```bash
wget https://raw.githubusercontent.com/tomav/docker-mailserver/master/setup.sh
chmod +x setup.sh
```

To test the e-mail delivery, you can use this website: https://www.mail-tester.com/

*Note: As a free user, you can check a maximum of 3 emails per day at mail-tester.com.*

You should have these domains:

* server.com or mail.server.com
* pop.server.com
* imap.server.com
* smtp.server.com

### Mail: Configure

Add email mailboxes or forwardings:

```bash
./setup.sh email list
./setup.sh email add user@website.com

./setup.sh alias list
./setup.sh alias add from@website.com to@website.com
```

### Mail: Certificate test

For the test on the server `0.0.0.0` and for the outside the domain or IP `website.com`.

```bash
# POP3, IMAP, SMTP, Alternative SMTP
openssl s_client -connect 0.0.0.0:110 -starttls pop3
openssl s_client -connect 0.0.0.0:143 -starttls imap
openssl s_client -connect 0.0.0.0:25 -starttls smtp
openssl s_client -connect 0.0.0.0:587 -starttls smtp

# POP3, IMAP, SMTP
openssl s_client -connect 0.0.0.0:995
openssl s_client -connect 0.0.0.0:993
openssl s_client -connect 0.0.0.0:465
```

### Mail: SPF

The simplest thing you can do is that only the current IP of your server is authorized to send emails.

To do this, a TXT entry must be created for your domain `website.com`.

```text
v=spf1 a mx ip4:192.1.2.3 ~all
```

### Mail: DKIM

#### Get DKIM & Configure DKIM in Plesk

German: Plesk > Tools & Einstellungen > E-Mail > Mailserver-Einstellungen > DKIM-Spamschutz

* German: Ausgehende E-Mails dürfen signiert werden > true
* German: Eingehende E-Mail-Nachrichten überprüfen > true

German: Plesk > Kunde > E-Mail > E-Mail Einstellungen > website.com

* German: DKIM-Spamschutzsystem zum Signieren ausgehender E-Mail-Nachrichten verwenden = true

Extract DKIM Key via OpenSSL:

```bash
openssl rsa -in /etc/domainkeys/website.comg/default -pubout
```

#### Get DKIM for Docker tvial/docker-mailserver

Generate DKIM keys:

```bash
? @todo ~/projects/mail/config/opendkim/keys/website.com

./setup.sh config dkim
docker-compose exec mail cat /tmp/docker-mailserver/opendkim/keys/website.com/mail.txt
./start.sh restart
```

The quotes must be combined:

```text
mail._domainkey IN TXT ( "v=DKIM1; h=sha256; k=rsa; p=MII/Long+Code/V1wIDAQAB" )
```

#### Save DKIM in DNS

You need to create a subdomain named `mail._domainkey`. The full domain is then `mail._domainkey.website.com`.

The code `v=DKIM1; h=sha256; k=rsa; p=MII/Long+Code/V1wIDAQAB` must then be entered as a `TXT` entry.


### Mail: SPF & DKIM test

You can check this on this page: https://www.mail-tester.com/spf-dkim-check

```text
Domain: website.com
Selector: mail
```

or manually:

```bash
dig +noall +answer website.com TXT
# website.com.	3600	IN	TXT	"v=spf1 a mx ip4:123.3.2.1 ~all"
dig +noall +answer mail._domainkey.website.com ANY
# mail._domainkey.website.com. 3491 IN TXT "v=DKIM1; h=sha256; k=rsa; p=MII/Long+Code/V1wIDAQAB"
```

### Mail: Reverse DNS Test

### Mail: Open Relay Test

Test whether open relay is deactivated. It is better to use real email addresses.

```bash
telnet mail.server.com 25
HELO other.com
MAIL FROM: user@other.com
RCPT TO:<user@gmail.com>
# 554 5.7.1 <user@gmail.com>: Relay access denied
QUIT
```

A look at the logs while sending, for example, reveals whether something is blocked somewhere.

```bash
docker-compose logs -f
```

To temporarily bypass certain blockages, you can set this a Docker environment variable:

```bash
POSTSCREEN_ACTION=ignore
```

### Mail: Spamassassin

Spamassassin learns automatically:

```bash
mkdir -p ~/projects/mail/.docker/mail/cron
vim ~/projects/mail/.docker/mail/cron/sa-learn
# Copy file .docker/mail/cron/sa-learn
```

Test spamassassin with E-Mail:

```bash
spamassassin -t -D < "/tmp/mail.eml"
```

### Mail: Roundcube

Create database:

```bash
~/projects/global/start.sh mysql
```

```sql
CREATE DATABASE `roundcube`;
CREATE USER 'roundcube'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON `roundcube`.* TO 'roundcube'@'%';
FLUSH PRIVILEGES;
```

### Mail: Roundmcube - ManageSieve (Filter)

Enable `ENABLE_MANAGESIEVE` and add RoundCube plugin `ROUNDCUBEMAIL_PLUGINS=managesieve` in `docker-compose.yaml`.

Edit `~/projects/mail/.docker/roundmail/config/config.inc.php` and add:

```php
    $config['managesieve_host'] = 'mail.server.com';
    $config['managesieve_usetls'] = true;
```
