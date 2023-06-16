# Linux: Background Processes

## Tmux

Tmux is said to be the better choice.

### Start Tmux

New session, session with a new name, session with a new name and command.

```bash
# New session
tmux

# New session, detached, session name and command
tmux new -d -s {sessionName} 'sleep 10'

# List sessions
tmux ls

# Detach or: Ctrl + b, then key 'd'
tmux detach
```

| Action             | Shortcut           |
| ------------------ | ------------------ |
| Detach             | Ctrl + B, then d   |
| Rename Tmux window | Ctrl + B, then ',' |
| Change Tmux window | Ctrl + B, then n   |

### Attach Tmux

Full or short command to attach.

```bash
tmux attach
tmux a -t {sessionName}
```

## Screen

Start the screen:

```bash
screen
screen -S {screenName}
```

Detach running screen: [STRG + A] dann [D]

Screen list:

```bash
screen -ls
```

Attach Screen:

```bash
screen -r
screen -r {screenName}
```
