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
```

## Available protocols

* imap-ssl
* imap-ssl-novalidate
* imap-tls

## Example

```bash
#!/usr/bin/env bash
set -e

# Synchronize
imap-sync.phar \
    --source imap-ssl://user1@website.org:password@mail.server.org:993/ \
    --target imap-ssl://user2@website.org:password@mail.server.org:993/

# Show folders with folder mapping
imap-sync.phar -v --listFolder \
    --source imap-ssl://user1@website.org:password@mail.server.org:993/ \
    --target imap-ssl://user2@website.org:password@mail.server.org:993/ \
    --mapFolder '{"Papierkorb": "Trash", "Spam": "Junk", "Gesendete Objekte": "Sent", "Entw&APw-rfe": "Drafts"}'

# Test synchronization, with extra parameters
imap-sync.phar -t -w -m 1024M \
    --source imap-ssl://user1@website.org:password@mail.server.org:993/ \
    --target imap-ssl://user2@website.org:password@mail.server.org:993/sub-folder
```

## Build package

```bash
./build.sh
```
