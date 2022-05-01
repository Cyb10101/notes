# Nautilus Extension: Visual Studio Code
# Copy to: nautilus ~/.local/share/nautilus-python/extensions
# pkill nautilus

from gi import require_version
require_version('Gtk', '3.0')
require_version('Nautilus', '3.0')

from gi.repository import Nautilus, GObject
from subprocess import call, run
import os

# Path to binary
codeBinary = 'code'

# Name in the context menu
codeName = 'Code'

# Change to True for always create new window
newWindow = False

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

class VisualStudioCodeExtension(GObject.GObject, Nautilus.MenuProvider):
    def launchVisualStudioCode(self, menu, files):
        safepaths = ''
        args = ''

        for file in files:
            filepath = file.get_location().get_path()
            safepaths += '"' + filepath + '" '

            # If one of the files we are trying to open is a folder - create a new instance of vscode
            if os.path.isdir(filepath) and os.path.exists(filepath):
                args = '--new-window '

        if newWindow:
            args = '--new-window '

        # App.msgInformation("Open Code...")
        call(codeBinary + ' ' + args + safepaths + '&', shell = True)

    def get_file_items(self, window, files):
        item = Nautilus.MenuItem(
            name = 'VisualStudioCodeOpen',
            label = 'Open in ' + codeName,
            tip = 'Opens the selected files with Visual Studio Code'
        )
        item.connect('activate', self.launchVisualStudioCode, files)
        return [item]

    def get_background_items(self, window, file):
        item = Nautilus.MenuItem(
            name = 'VisualStudioCodeOpenBackground',
            label = 'Open in ' + codeName,
            tip = 'Opens the current directory in Visual Studio Code'
        )
        item.connect('activate', self.launchVisualStudioCode, [file])
        return [item]
