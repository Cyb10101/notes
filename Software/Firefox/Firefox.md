# Firefox

Configure url: [about:config](about:config)

## user.js

```javascript
// Don't open download panel on new downloads
user_pref("browser.download.alwaysOpenPanel", false);
```

## Enable touch-scrolling in Firefox

Edit `/etc/security/pam_env.conf` and add this line:

```text
MOZ_USE_XINPUT2 DEFAULT=1
```

Log out and in again.

## Remove all service worker

Open developer console on: [about:serviceworkers](about:serviceworkers)

```javascript
document.querySelectorAll('#serviceworkers div button').forEach(e => e.click())
```

## Enable touch

* [firefox-enable-touch.sh](firefox-enable-touch.sh)
* [firefox-enable-touch-snap.sh](firefox-enable-touch-snap.sh)

## Disable Pocket

```text
extensions.pocket.enabled = false
```

## Reader view

reader.content_width = 9

## Switch off full screen message

full-screen-api.warning.timeout = -1
#full-screen-api.warning.timeout = 1

## HTTP: Deactivate security warning for input fields

security.insecure_field_warning.contextual.enabled = false

## No automatic www prefix

browser.fixup.alternate.enabled = false
browser.urlbar.autoFill = false

## Set default volume (Works only for default player)

media.default_volume = 0.3

## Dark mode

Currently choosen from theme without config. Maybe a bug:

* [bugzilla 1736218](https://bugzilla.mozilla.org/show_bug.cgi?id=1736218)
* [Diff D128700](https://phabricator.services.mozilla.com/D128700)
* [CSS prefers-color-scheme](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme)

Fix it with:

User prefers color scheme [0 = Dark, 1 = Light, 2 = System, 3 = Browser]:
layout.css.prefers-color-scheme.content-override = 2

*Keywords: Content black by dark themes*

## Firefox change user agent

Get user agent via Javascript:

```javascript
navigator.userAgent
```

* Open Firefox configuration with `about:config`
* Add `general.useragent.override` as string

```yaml
# Windows 11 Edge
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36 Edg/90.0.818.66
```

## Development

Double encoding - Disable encoding (Gzip):

```text
network.http.accept-encoding = ""
```

## Extract jsonlz4 file

```bash
sudo apt install python3-virtualenv python3-venv python3-distutils-extra
python3 -m venv venv
source venv/bin/activate
python3 -m pip install --upgrade pip lz4
```

File `extract-jsonlz4.sh input.jsonlz4 output.json`:

```python
#!/usr/bin/env python3
import sys
import json
import lz4.block

input_file = sys.argv[1]
output_file = sys.argv[2]

with open(input_file, "rb") as file:
    data = file.read()

if not data.startswith(b"mozLz40\0"):
    raise SystemExit("Not a Firefox jsonlz4 file")

decompressed = lz4.block.decompress(data[8:])

with open(output_file, "wb") as file:
    file.write(decompressed)
```

## Statistics

Therapeutic measure to display almost insignificant statistics about browser use.

- [firefox-bookmark-tree.py](firefox-bookmark-tree.py)
- [firefox-tab-tree.py](firefox-tab-tree.py)

### Statistics from bookmarks

[Extract bookmarks](https://support.mozilla.org/en-US/kb/restore-bookmarks-from-backup-or-move-them#w_manual-backup):

- Menu > Bookmarks > Manage bookmarks
- Import and Backup > Backup

```bash
# Store firefox profile folder in a variable
FIREFOX_PROFILE=~/.mozilla/firefox/f1r3f0x.default-release

# Show top bookmarked domains
lz4jsoncat "$(ls $FIREFOX_PROFILE/bookmarkbackups/*.jsonlz4 | tail -1)" | jq -r '
  .. | objects | select(.type == "text/x-moz-place" and .uri) | .uri | select(test("^https?://"))
  | capture("^https?://(?<host>[^/]+)")? | .host | sub("^www\\."; "")
' | sort | uniq -c | sort -nr | head -n 20

# Show duplicate bookmark URLs
lz4jsoncat "$(ls $FIREFOX_PROFILE/bookmarkbackups/*.jsonlz4 | tail -1)" | \
  jq -r '.. | objects | select(.type == "text/x-moz-place" and .uri) | .uri' | sort | uniq -c | sort -nr | awk '$1 > 1'
```

### Statistics from open tabs via Addon

- [Addon: Export Tabs URLs](https://addons.mozilla.org/en-US/firefox/addon/export-tabs-urls-and-titles/)

```bash
# Top domains from open tabs (Use "Export Tab Urls" extension)
sed -r 's/https?:\/\/(www\.)?([^\/]+)\/.*/\2/g' firefox-tabs.txt | sort | uniq -c | sort -nr | head -n 20
```

### Statistics from open tabs via recovery.json

Navigate to to your firefox profile and extract `sessionstore-backups/recovery.jsonlz4`.

```bash
sudo apt install lz4json

# Store firefox profile folder in a variable
FIREFOX_PROFILE=~/.mozilla/firefox/f1r3f0x.default-release

# Top domains from open tabs
lz4jsoncat "$FIREFOX_PROFILE/sessionstore-backups/previous.jsonlz4" | jq -r '
  .windows[].tabs[] | .entries[.index - 1].url | select(type == "string")
  | capture("^[a-zA-Z]+://(?<host>[^/]+)")? | .host | sub("^www\\."; "")
' | sort | uniq -c | sort -nr | head -n 20

# Duplicate URLs
lz4jsoncat "$FIREFOX_PROFILE/sessionstore-backups/previous.jsonlz4" | \
  jq -r '.windows[].tabs[] | .entries[.index - 1].url | select(type == "string")' | sort | uniq -c | sort -nr | awk '$1 > 1'

# Tabs per group
lz4jsoncat "$FIREFOX_PROFILE/sessionstore-backups/previous.jsonlz4" | \
  jq -r '.windows[] as $w | (($w.groups // []) | map({(.id): .name}) | add // {}) as $g |
       $w.tabs[] | $g[.groupId // "-"] // "(ungrouped)"' |
  sort | uniq -c | sort -rn
```
