# Windows: Shutdown

Some systems, such as Linux, require that Windows be completely shut down and not in a hibernation state so that the hard disk can be accessed.

*Keywords: Hibernation, Fast Startup, Hybrid Boot, Hybrid Shutdown, Complete Shutdown, Full Shutdown*

## Shut down completely temporarily

See: [Scripts/Complete-shutdown.lnk](Scripts/Complete-shutdown.lnk)

Run as Administrator in Command/Powershell:

```bash
%windir%\system32\shutdown.exe /s /t 0
```

## Permanently shut down completely

Switch off hibernation.

Run as Administrator in Command/Powershell:

```bash
powercfg.exe /h off
```
