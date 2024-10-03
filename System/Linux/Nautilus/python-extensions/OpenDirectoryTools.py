# sudo apt -y install python3-nautilus
# Copy to: nautilus ~/.local/share/nautilus-python/extensions
# nautilus -q

import os
from urllib.parse import unquote
from gi.repository import Nautilus, GObject
from typing import List
from subprocess import call, run, getstatusoutput

debug = False
#debug = True

# Change to True for always create new window
codiumNewWindow = False

class App():
    @classmethod
    def msg(self, message, icon):
        run(["/usr/bin/notify-send", "--icon=" + icon, message])

    @classmethod
    def msgError0(self, message):
        self.msg(message, "error")

    @classmethod
    def msgInformation(self, message):
        self.msg(message, "dialog-information")

    @classmethod
    def msgApply(self, message):
        self.msg(message, "dialog-apply")

    @classmethod
    def msgWarning(self, message):
        self.msg(message, "dialog-warning")

    @classmethod
    def msgError(self, message):
        self.msg(message, "dialog-error")

statusCodium, _ = getstatusoutput("hash codium")
existsCodium = statusCodium == 0

statusGitFiend, _ = getstatusoutput("flatpak info com.gitfiend.GitFiend")
existsGitFiend = statusGitFiend == 0

class OpenDirectoryTools(GObject.GObject, Nautilus.MenuProvider):
    #def __init__(self):
    #    super().__init__()
    #    print("Initialized OpenDirectoryTools extension")

    def _openTest(self, menu: Nautilus.MenuItem, files: List[Nautilus.FileInfo]) -> None:
        # App.msgInformation("Run Test...")
        for file in files:
            filename = unquote(file.get_uri()[7:])
            print("File object:", file)
            print("-> Name:", filename)
            print("-> Path:", file.get_location().get_path())

    def _openTerminal(self, menu: Nautilus.MenuItem, files: List[Nautilus.FileInfo]) -> None:
        for file in files:
            filename = unquote(file.get_uri()[7:])
            os.chdir(filename)
            os.system("gnome-terminal")

    def _openGitFiend(self, menu: Nautilus.MenuItem, files: List[Nautilus.FileInfo]) -> None:
        safepath = '"' + files[0].get_location().get_path() + '"'
        call('nohup flatpak run com.gitfiend.GitFiend ' + safepath + ' 2>&1 >/dev/null  &', shell = True)

    def _openCodium(self, menu: Nautilus.MenuItem, files: List[Nautilus.FileInfo]) -> None:
        safepaths = ''
        args = ''

        for file in files:
            filepath = file.get_location().get_path()
            safepaths += '"' + filepath + '" '

            # If one of the files we are trying to open is a folder - create a new instance of vscodium
            if os.path.isdir(filepath) and os.path.exists(filepath):
                args = '--new-window '

        if codiumNewWindow:
            args = '--new-window '

        call('codium ' + args + safepaths + ' &', shell = True)

    def get_file_items(self, files: List[Nautilus.FileInfo]) -> List[Nautilus.MenuItem]:
        if len(files) < 1:
            return []

        for file in files:
            if not file.is_directory() or file.get_uri_scheme() != "file":
                return []

        if debug:
            itemDebug = Nautilus.MenuItem(
                name = __class__.__name__ + "Items::MenuDebug",
                label = "Debug",
                tip = "",
                icon = "",
            )
            itemDebugSubmenu = Nautilus.Menu()
            itemDebug.set_submenu(itemDebugSubmenu)

            itemTest = Nautilus.MenuItem(
                name = __class__.__name__ + "Items::OpenTest",
                label = "Open in Test",
                tip = "Open selected files in Test",
                icon = "",
            )
            itemTest.connect("activate", self._openTest, files)
            itemDebugSubmenu.append_item(itemTest)

            itemTerminal = Nautilus.MenuItem(
                name = __class__.__name__ + "Items::OpenTerminal",
                label = "Open in Test-Terminal",
                tip = "Open selected files in Test-Terminal",
            )
            itemTerminal.connect("activate", self._openTerminal, files)
            itemDebugSubmenu.append_item(itemTerminal)

        if existsCodium:
            itemCodium = Nautilus.MenuItem(
                name = __class__.__name__ + "Items::OpenCodium",
                label = "Open in Codium",
                tip = "Open selected files in Codium",
            )
            itemCodium.connect("activate", self._openCodium, files)

        if len(files) == 1:
            itemGitFiend = Nautilus.MenuItem(
                name = __class__.__name__ + "Items::OpenGitFiend",
                label = "Open in GitFiend",
                tip = "Open selected files '%s' in GitFiend" % files[0].get_name(),
            )
            itemGitFiend.connect("activate", self._openGitFiend, files)

        returnList = []
        if debug:
            returnList.append(itemDebug)
        if existsCodium:
            returnList.append(itemCodium)
        if len(files) == 1:
            returnList.append(itemGitFiend)
        return returnList

    def get_background_items(self, file: Nautilus.FileInfo) -> List[Nautilus.MenuItem]:
        if debug:
            itemDebug = Nautilus.MenuItem(
                name = __class__.__name__ + "Background::MenuDebug",
                label = "Debug",
                tip = "",
                icon = "",
            )
            itemDebugSubmenu = Nautilus.Menu()
            itemDebug.set_submenu(itemDebugSubmenu)

            itemTest = Nautilus.MenuItem(
                name = __class__.__name__ + "Background::OpenTest",
                label = "Open in Test",
                tip = "Open '%s' in Test " % file.get_name(),
            )
            itemTest.connect("activate", self._openTest, [file])
            itemDebugSubmenu.append_item(itemTest)

            itemTerminal = Nautilus.MenuItem(
                name = __class__.__name__ + "Background::OpenTerminal",
                label = "Open in Test-Terminal",
                tip = "Open '%s' in Test-Terminal " % file.get_name(),
            )
            itemTerminal.connect("activate", self._openTerminal, [file])
            itemDebugSubmenu.append_item(itemTerminal)

        if existsCodium:
            itemCodium = Nautilus.MenuItem(
                name = __class__.__name__ + "Background::OpenCodium",
                label = "Open in Codium",
                tip = "Open '%s' in Codium" % file.get_name(),
            )
            itemCodium.connect("activate", self._openCodium, [file])

        itemGitFiend = Nautilus.MenuItem(
            name = __class__.__name__ + "Background::OpenGitFiend",
            label = "Open in GitFiend",
            tip = "Open '%s' in GitFiend" % file.get_name(),
        )
        itemGitFiend.connect("activate", self._openGitFiend, [file])

        returnList = []
        if debug:
            returnList.append(itemDebug)
        if existsCodium:
            returnList.append(itemCodium)
        returnList.append(itemGitFiend)
        return returnList
