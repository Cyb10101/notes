# Windows PE Builder

* [Intro](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-intro)
* [Optional Components Reference](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-add-packages--optional-components-reference)

## Build

Download ADK for Windows:

* [Windows ADK](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install)

Install "Windows ADK" & "WinPE-Add-On for the Windows ADK":

* Install "Windows ADK": adksetup.exe
* Install "WinPE-Add-On for the Windows ADK": adkwinpesetup.exe

Run `build.cmd` to create bootable image here on `C:\WinPE`.

*Note: startnet.cmd is the better option to load multiple software, instead of winpeshl.ini*
