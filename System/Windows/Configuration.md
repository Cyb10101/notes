# Windows: Configuration

## Open programs when restarting

Do not open programs when restarting:

```text
Settings > Accounts > Sign In Options > Privacy
> Use my credentials to set up the device
   automatically complete after an update or restart
   and reopen my apps = false
```

## Fastboot

Disable fast boot:

```text
Control Panel > System and Security > Power Options
> Option: Select what should happen when you press the power button
> Link: Some settings are currently not available
> Activate quick start = false
```

## Activate Num key

Activate number field at start.

```text
Run: Regedit.exe
HKEY_USERS\.Default\Control Panel\Keyboard
(Eventuell auch HKEY_CURRENT_USER\Control Panel\Keyboard)
InitialKeyboardIndicators = 2147483650
```

If the `InitialKeyboardIndicators` value is:

* 0, change to 2.
* 2147483648, change to 2147483650.
