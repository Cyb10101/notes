# Firefox

Configure url: [about:config](about:config)

## Disable Pocket

extensions.pocket.enabled = false

## Double encoding - Disable encoding (Gzip)

network.http.accept-encoding = ""

## Switch off full screen message

full-screen-api.warning.delay = 0
full-screen-api.warning.timeout = 0

## HTTP: Deactivate security warning for input fields

security.insecure_field_warning.contextual.enabled = false

## No automatic www prefix

browser.fixup.alternate.enabled = false
browser.urlbar.autoFill = false
