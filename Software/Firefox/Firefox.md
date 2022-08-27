# Firefox

Configure url: [about:config](about:config)

## Enable touch

* [firefox-enable-touch.sh](firefox-enable-touch.sh)
* [firefox-enable-touch-snap.sh](firefox-enable-touch-snap.sh)

## Disable Pocket

```text
extensions.pocket.enabled = false
```

## Switch off full screen message

full-screen-api.warning.delay = 0
full-screen-api.warning.timeout = 0

## HTTP: Deactivate security warning for input fields

security.insecure_field_warning.contextual.enabled = false

## No automatic www prefix

browser.fixup.alternate.enabled = false
browser.urlbar.autoFill = false

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
