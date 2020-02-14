# Linux: Background Processes

## Tmux

Tmux is said to be the better choice.

### Start Tmux

New session, session with a new name, session with a new name and command.

```bash
tmux
tmux new -s {sessionName}
tmux new -s {sessionName} '{command}'
```

### Detach running tmux

Either as a command: [STRG + B] then [D]

Or in Tmux Console:

```bash
tmux detach
```

### Show Tmux list

```bash
tmux ls
```

### Rename Tmux window

[STRG + B] dann [,]

### Change Tmux window

[STRG + B] dann [n]

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
