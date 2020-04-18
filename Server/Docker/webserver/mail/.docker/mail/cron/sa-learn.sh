#!/usr/bin/env bash

sa-learn --no-sync --spam /var/mail/*/*/.Junk --dbpath /var/mail-state/lib-amavis/.spamassassin
sa-learn --no-sync --ham /var/mail/*/*/.Archive* --dbpath /var/mail-state/lib-amavis/.spamassassin
sa-learn --no-sync --ham /var/mail/*/*/cur* --dbpath /var/mail-state/lib-amavis/.spamassassin
sa-learn --sync
