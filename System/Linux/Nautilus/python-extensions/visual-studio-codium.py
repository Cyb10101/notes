# Nautilus Extension: Visual Studio Codium
# sudo apt -y install python3-nautilus
# Copy to: nautilus ~/.local/share/nautilus-python/extensions
# pkill nautilus

from gi import require_version
require_version('Gtk', '3.0')
require_version('Nautilus', '3.0')

from gi.repository import Nautilus, GObject
from subprocess import call, run
import os

# Path to binary
codiumBinary = 'codium'

# Name in the context menu
codiumName = 'Codium'

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

class VisualStudioCodiumExtension(GObject.GObject, Nautilus.MenuProvider):
    def launchVisualStudioCodium(self, menu, files):
        safepaths = ''
        args = ''

        for file in files:
            filepath = file.get_location().get_path()
            safepaths += '"' + filepath + '" '

            # If one of the files we are trying to open is a folder - create a new instance of vscodium
            if os.path.isdir(filepath) and os.path.exists(filepath):
                args = '--new-window '

        if newWindow:
            args = '--new-window '

        # App.msgInformation("Open Codium...")
        call(codiumBinary + ' ' + args + safepaths + '&', shell = True)

    def get_file_items(self, window, files):
        item = Nautilus.MenuItem(
            name = 'VisualStudioCodiumOpen',
            label = 'Open in ' + codiumName,
            tip = 'Opens the selected files with Visual Studio Codium'
        )
        item.connect('activate', self.launchVisualStudioCodium, files)
        return [item]

    def get_background_items(self, window, file):
        item = Nautilus.MenuItem(
            name = 'VisualStudioCodiumOpenBackground',
            label = 'Open in ' + codiumName,
            tip = 'Opens the current directory in Visual Studio Codium'
        )
        item.connect('activate', self.launchVisualStudioCodium, [file])
        return [item]
