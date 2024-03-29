# Docker: Webserver

@todo add fail2ban to ssh docker
@todo add nginx html pages
@todo apt install mariadb-client

Example structure of a Webserver:

* global: Nginx reverse proxy
* mail: Mail System + Roundmail website
* user_cyb10101: Shares SSH & Composer data, SSH/SFTP Server
* website_www: Website only
* Based on Ubuntu 20.04

## Security

Copy local ssh id to server:

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub root@server
```

Login to server with ssh key, change root password and create new user:

```bash
ssh root@server.com
passwd root
adduser username
```

### Install essentials

```bash
apt -y install curl jq rdiff-backup ncdu htop
```

### SSH root login

```bash
vim /etc/ssh/sshd_config
```

```text
# Disable passwort login
PermitRootLogin prohibit-password

# Disable all
PermitRootLogin no
```

```bash
systemctl restart ssh
```

### Change SSH Port

```bash
vim /etc/ssh/sshd_config
```

```text
Port 2200
ListenAddress 0.0.0.0
ListenAddress ::
```

```bash
systemctl restart ssh
ssh user@server.com -p2200
```

## Motd (Message of the day)

To disable all messages:

```bash
touch ${HOME}/.hushlogin
```

Disable last ssh login with `PrintLastLog no`:

```bash
vim /etc/ssh/sshd_config
systemctl restart ssh
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
apt install fail2ban
vim /etc/fail2ban/jail.d/jail.local
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
service fail2ban restart
fail2ban-client status
fail2ban-client status sshd
```

## Docker

* [Docker Installation](../Installation.md)

Copy files and configure it. But don't start yet.

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

*Note: Test this after mail started.*

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
apt -y install nmap
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
mkdir -p ~/projects/global/.docker/global-nginx-proxy/certs
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
    -keyout ~/projects/global/.docker/global-nginx-proxy/certs/default.key \
    -out ~/projects/global/.docker/global-nginx-proxy/certs/default.crt
```

## Web: User permissions

Always think for user permissions, especially when content is connected to Docker!

```bash
chown -R 1000:1000 .
```

**Security note:** If you connect other instances with same volumes, for example a global read only SSH key or a Composer cache directory, other users can have access to private content. If you really need it, it is safer to store it in your own instance.

## Start global

```bash
~/projects/global/start.sh up
```

## MySQL / MariaDB

*Note: Database username, up to 16 alphanumeric characters, underscore and dash are allowed.*

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
/* Show database and user */
SELECT Host, Db, User FROM mysql.db;
SELECT User, Host FROM mysql.user;

/* Show grants */
SHOW GRANTS FOR 'username'@'%';

/* Get drop username sql */
SELECT CONCAT("DROP USER '", user, "'", "@", "'", HOST, "';") AS `SQL` FROM mysql.db WHERE `Db` IN ('website1_www');

/* Drop database and user */
DROP DATABASE `website_www`;
DROP USER 'username'@'%';
FLUSH PRIVILEGES;
```

## Mail

* [docker-mailserver/docker-mailserver](https://github.com/docker-mailserver/docker-mailserver)

```bash
./start.sh setup help

./start.sh setup email list
./start.sh setup email add <EMAIL ADDRESS> [<PASSWORD>]
./start.sh setup email update <EMAIL ADDRESS> [<PASSWORD>]
./start.sh setup email del [ OPTIONS... ] <EMAIL ADDRESS> [ <EMAIL ADDRESS>... ]
./start.sh setup email restrict <add|del|list> <send|receive> [<EMAIL ADDRESS>]

./start.sh setup alias list
./start.sh setup alias add <EMAIL ADDRESS> <RECIPIENT>
./start.sh setup alias del <EMAIL ADDRESS> <RECIPIENT>

./start.sh setup quota set <EMAIL ADDRESS> [<QUOTA>]
./start.sh setup quota del <EMAIL ADDRESS>

./start.sh setup config dkim [ ARGUMENTS... ]

./start.sh setup debug fetchmail
./start.sh setup debug fail2ban [unban <IP>]
./start.sh setup debug show-mail-logs
```

To test the e-mail delivery, you can use this website: https://www.mail-tester.com/

*Note: As a free user, you can check a maximum of 3 emails per day at mail-tester.com.*

You should have these domains:

* server.com or mail.server.com
* pop.server.com
* imap.server.com
* smtp.server.com

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

*Note: If you change roundcube plugins or configuration, you maybe need to delete this folder `.docker/roundmail`. But be careful! Manual configurations could have been written in `.docker/roundmail/config/config.inc.php`.*

### Mail: Autoconfig & AutoDiscover

This service is optional and is used to ensure that the mail programs receive the configuration automatically.

Configure service `autodiscover` in `mail/docker-compose.yml`.

* [Monogramm/autodiscover-email-settings](https://github.com/Monogramm/autodiscover-email-settings)
* [Mozilla Autoconfig](https://developer.mozilla.org/en-US/docs/Mozilla/Thunderbird/Autoconfiguration/FileFormat/HowTo)

### Start mail

```bash
~/projects/mail/start.sh up
```

### Mail: Configure

Add email mailboxes or forwardings:

```bash
./start.sh setup email list
./start.sh setup email add user@website.com

./start.sh setup alias list
./start.sh setup alias add from@website.com to@website.com
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
openssl rsa -in /etc/domainkeys/website.com/default -pubout
```

#### Get DKIM for Docker tvial/docker-mailserver

Generate DKIM keys:

```bash
./start.sh setup config dkim
ls -1 ~/projects/mail/.docker/mail/config/opendkim/keys
cat ~/projects/mail/.docker/mail/config/opendkim/keys/website.com/mail.txt
~/projects/mail/start.sh down && ~/projects/mail/start.sh up
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
Selector: mail (Standard is maybe 'default')
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

### Mail: Sieve

Global Sieve spam filter:

```bash
vim ~/projects/mail/.docker/mail/before.dovecot.sieve
vim ~/projects/mail/.docker/mail/after.dovecot.sieve
# Copy and ajust file .docker/mail/*.dovecot.sieve
```

### Mail: Roundcube - Configure

Edit `~/projects/mail/.docker/roundmail/config/config.inc.php` and add:

```php
  $config['htmleditor'] = 4; // always compose html formatted messages, except when replying to plain text message
```

### Mail: Roundmcube - ManageSieve (Filter)

Enable `ENABLE_MANAGESIEVE` and add RoundCube plugin `ROUNDCUBEMAIL_PLUGINS=managesieve` in `docker-compose.yaml`.

Edit `~/projects/mail/.docker/roundmail/config/config.inc.php` and add:

```php
    $config['managesieve_host'] = 'mail.server.com';
    $config['managesieve_usetls'] = true;
```

## Nextcloud

* [Thunderbird: CardBook](https://addons.thunderbird.net/de/thunderbird/addon/cardbook/)

Create database:

```sql
CREATE DATABASE `nextcloud`;
CREATE USER 'nextcloud'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON `nextcloud`.* TO 'nextcloud'@'%';
FLUSH PRIVILEGES;
```

Start Docker and remove or ajust skeleton for new users:

```bash
~/projects/nextcloud/start.sh up
rm -rf ~/projects/nextcloud/.docker/nextcloud/core/skeleton/*
```

Edit `~/projects/nextcloud/.docker/nextcloud/config/config.php`:

```php
$CONFIG = array(
  'default_phone_region' => 'DE',
  'trashbin_retention_obligation' => 'auto, 30', // Delete trash files: older than x days, other anytime if space needed
  'versions_retention_obligation' => 'auto, 7', // Delete versions: older than x days, other according to expiration rules
);
```

* [Config: Trash bin](https://docs.nextcloud.com/server/18/admin_manual/configuration_server/config_sample_php_parameters.html#deleted-items-trash-bin)
* [Config: File versioning](https://docs.nextcloud.com/server/18/admin_manual/configuration_server/config_sample_php_parameters.html#file-versions)

Restart Docker container:

```bash
~/projects/nextcloud/start.sh down && ~/projects/nextcloud/start.sh up
```

[Settings > Administration > Basic Settings](https://nextcloud.cyb21.de/settings/admin)

* Background jobs = Cron
