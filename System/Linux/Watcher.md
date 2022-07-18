# Watcher

## Watch

Do a command every '-n' seconds.

```bash
watch -n 2 "cp /media/sf_public/*.py ~/.local/share/nautilus-python/extensions/"
```

## Inotify

Wait until something in filesystem happen.

*Note: VirtualBox or shared folder, don't recognize changes.*

```bash
sudo apt -y install inotify-tools

# Only one file on modify event
while inotifywait -e modify ~/script.sh; do cp ~/script.sh ~/Downloads/public/; done

# Just rsync
while true; do \
  inotifywait -r -e modify,attrib,close_write,move,create,delete ~/Sync/notes; \
  sleep 1;
  rsync -av ~/Sync/notes/ ~/Downloads/public/notes/; \
  done

# @todo Maybe not working with multiple folder
# Better with copy: -r = recursiv
inotifywait -q -m -e modify,delete,create ~/Sync/notes | while read DIRECTORY EVENT FILE; do \
    if [[ "${FILE}" =~ .*py$ ]]; then echo "${EVENT} ${DIRECTORY} ${FILE}"; \
    cp "${DIRECTORY}${FILE}" ~/Downloads/public/; fi; done
```
