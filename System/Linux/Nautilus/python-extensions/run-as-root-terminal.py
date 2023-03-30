# Nautilus Extension: Run as root in terminal
# sudo apt -y install python3-nautilus
# mkdir -p ~/.local/share/nautilus-python/extensions
# Copy to: nautilus ~/.local/share/nautilus-python/extensions
# pkill nautilus

from gi import require_version
require_version('Gtk', '3.0')
require_version('Nautilus', '3.0')

from gi.repository import Nautilus, GObject
from subprocess import call, run
import os

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

class RunAsRootTerminalExtension(GObject.GObject, Nautilus.MenuProvider):
    def launchRunAsRootTerminal(self, menu, files):
        safepaths = ''
        isDirectory = False

        for file in files:
            filepath = file.get_location().get_path()
            safepaths += '"' + filepath + '" '

        if os.path.isdir(filepath) and os.path.exists(filepath):
            isDirectory = True

        # App.msgInformation("Open Code...")
        if isDirectory:
            call('gnome-terminal -- sudo ${SHELL} -c \'cd ' + safepaths + ' && ${SHELL}\'&', shell = True)
        else:
            call('gnome-terminal -- sudo ' + safepaths + '&', shell = True)

    def get_file_items(self, window, files):
        item = Nautilus.MenuItem(
            name = 'RunAsRootTerminal',
            label = 'Run as root in terminal',
            tip = 'Opens a terminal an run command as root'
        )
        item.connect('activate', self.launchRunAsRootTerminal, files)
        return [item]

    def get_background_items(self, window, file):
        item = Nautilus.MenuItem(
            name = 'RunAsRootTerminalBackground',
            label = 'Run as root in terminal',
            tip = 'Opens a terminal an run command as root'
        )
        item.connect('activate', self.launchRunAsRootTerminal, [file])
        return [item]
