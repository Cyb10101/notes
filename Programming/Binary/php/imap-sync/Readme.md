# IMAP Sync

Migrate or synchronize the emails between two servers.

## Requirements

* PHP 7.4+

## Parameter

```text
Required:
--source                    Source server
--target                    Target server

Optional:
-v, --verbose               Verbose output
-t, --test, --dry-run       Test run, do nothing
--listFolder                Only list folder, no synchronizing
-w, --wipe                  Remove all messages on target
--mapFolder                 JSON to map between folders
-m, --memory                PHP Memory Limit

Optional overwrite parameters:
--sourceUsername            Overwrite source username
--sourcePassword            Overwrite source password
--targetUsername            Overwrite target username
--targetPassword            Overwrite target password
```

## Available protocols

* imap-ssl
* imap-ssl-novalidate
* imap-tls

## Examples

Synchronize mails between server:

```bash
# Just list folder
imap-sync.phar --listFolder \
    --source '{"url": "imap-ssl://mail.server.org:993/", "username": "user1@website.org", "password": "PassWord"}' \
    --target '{"url": "imap-ssl://mail.server.org:993/", "username": "user2@website.org", "password": "PassWord"}'

# Synchronize
imap-sync.phar -v \
    --source '{"url": "imap-ssl://mail.server.org:993/", "username": "user1@website.org", "password": "PassWord"}' \
    --target '{"url": "imap-ssl://mail.server.org:993/", "username": "user2@website.org", "password": "PassWord"}'
```

Show folders with folder mapping:

```bash
imap-sync.phar --listFolder \
    --source '{"url": "imap-ssl://mail.server.org:993/", "username": "user1@website.org", "password": "PassWord"}' \
    --target '{"url": "imap-ssl://mail.server.org:993/", "username": "user2@website.org", "password": "PassWord"}' \
    --mapFolder '{"Papierkorb": "Trash", "Spam": "Junk", "Gesendete Objekte": "Sent", "Entw&APw-rfe": "Drafts"}'
```

Synchronize with new source markup and old target markup:

```bash
imap-sync.phar \
    --source '{"url": "imap-ssl://mail.server.org:993/", "username": "user1@website.org", "password": "PassWord"}' \
    --target 'imap-ssl://user2@website.org:password@mail.server.org:993/'
```

Synchronize and overwrite fields username and password (you should not need that):

```bash
imap-sync.phar \
    --source '{"url": "imap-ssl://mail.server.org:993/", "username": "oldUsername", "password": "oldPassword"}' --sourceUsername 'newUsername' --sourcePassword 'newPassword' \
    --target 'imap-ssl://oldUsername:oldPassword@mail.server.org:993/' --targetUsername 'newUsername' --targetPassword 'oldPassword'
```

## Script example

```bash
#!/usr/bin/env bash
set -e

# Test synchronization, with extra parameters
imap-sync.phar -t -w -m 1024M \
    --source '{"url": "imap-ssl://mail.server.org:993/", "username": "user1@website.org", "password": "PassWord"}' \
    --target '{"url": "imap-ssl://mail.server.org:993/subfolder", "username": "user2@website.org", "password": "PassWord"}' \
    --mapFolder '{"Papierkorb": "Trash", "Spam": "Junk", "Gesendete Objekte": "Sent", "Entw&APw-rfe": "Drafts"}'
```

## Build package

```bash
./build.sh
```
