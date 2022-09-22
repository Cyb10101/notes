# Linux Fun

## Lolcat

```bash
sudo apt -y install lolcat
alias ll='ls -l | lolcat'
unalias ll
```

## Cowsay & Cowthink

```bash
sudo apt -y install cowsay

ls | cowsay -n

cowsayRandom() { \
    if [ -n "$ZSH_VERSION" ]; then fixIndex=1; else fixIndex=0; fi; \
    local cowBin=( cowsay cowthink ); \
    local cowFile=( default cock daemon eyes fox ghostbusters milk moose stegosaurus tux ); \
    if [ -p /dev/stdin ]; then \
        cat | ${cowBin[ $RANDOM % ${#cowBin[@]} + ${fixIndex}]} -n -f ${cowFile[ $RANDOM % ${#cowFile[@]} + ${fixIndex} ]}; \
    else \
        echo "${@}" | fold -s -w 70 | ${cowBin[ $RANDOM % ${#cowBin[@]} + ${fixIndex} ]} -n -f ${cowFile[ $RANDOM % ${#cowFile[@]} + ${fixIndex} ]}; \
    fi; \
}
ls | cowsayRandom
cowsayRandom What a message
```

## Toilet

```bash
sudo apt -y install toilet
toilet Awesome
toilet -f term -F border --gay Rainbow
toilet -f mono12 -F border --gay Rainbow
```

## Figlet

```bash
sudo apt -y install figlet
echo 'This is awesome!' | figlet
```

## Boxes

```bash
sudo apt -y install boxes
boxes -l
echo 'This is awesome!' | boxes -d boxquote

boxesRandom() { \
    if [ -n "$ZSH_VERSION" ]; then fixIndex=1; else fixIndex=0; fi; \
    local box=( bear boy boxquote c-cmt2 capgirl cat cc columns dog face girl ian_jones jstone nuke mouse peek parchment santa stone ); \
    if [ -p /dev/stdin ]; then \
        cat | boxes -d "${box[ $RANDOM % ${#box[@]} + ${fixIndex} ]}"; \
    else \
        echo "${@}" | fold -s -w 76 | boxes -d ${box[ $RANDOM % ${#box[@]} + ${fixIndex} ]}; \
    fi; \
}
ls | boxesRandom
boxesRandom What a message
```

## Fortune cookies

```bash
# sudo apt -y install cowsay boxes lolcat
sudo apt -y install fortune fortunes-de
sudo apt -y install fortunes-debian-hints fortunes-ubuntu-server fortunes-off fortunes-mario fortunes-bofh-excuses

# Data files containing selected fortune cookies ???
sudo apt -y install fortunes-min

# Search fortunes
ls -I '*.dat' -I '*.u8' /usr/share/games/fortunes

# List localized language
fortune -f

# List all without language
fortune -a -f

# List all
fortune -a -f .. de off

# Show localized fortunes
fortune -a

# Show all fortunes (bad because loads all)
fortune -a .. de off

# Show selected fortunes
fortune -a de off

# Random fortune boxes, Need: boxesRandom & cowsayRandom
randomFortune() { \
    if [ -n "$ZSH_VERSION" ]; then fixIndex=1; else fixIndex=0; fi; \
    local fortune=$(fortune -a); \
    local randomBin=( box cowsay ); \
    randomBin=${randomBin[ $RANDOM % ${#randomBin[@]} + ${fixIndex} ]}; \
    if [ ${randomBin} == 'box' ]; then \
        echo "${fortune}" | fold -s -w 76 | boxesRandom | lolcat; \
    else \
        echo "${fortune}" | fold -s -w 70 | cowsayRandom | lolcat; \
    fi; \
}

# fortuneBoxQuote art computers
fortuneBoxQuote() { \
    local fortune=$(fortune -a -c ${@}); \
    local title=$(echo -e "$fortune" | head -1 | sed 's/[()]//g; s|\/usr\/share\/games\/fortunes\/||g'); \
    local text=$(echo -e "$fortune" | tail -n +3); \
    echo "${text}" | fold -s -w 76 | boxes -d boxquote | sed "s|\[  \]|[${title}]|" | lolcat; \
}

# randomFortuneBoxQuote
randomFortuneBoxQuote() { \
    local fortune=$(fortune -a -c); \
    local title=$(echo -e "$fortune" | head -1 | sed 's/[()]//g; s|\/usr\/share\/games\/fortunes\/||g'); \
    local text=$(echo -e "$fortune" | tail -n +3); \
    echo "${text}" | fold -s -w 76 | boxes -d boxquote | sed "s|\[  \]|[${title}]|" | lolcat; \
}

# randomFortuneChosen art computers
randomFortuneChosen() { \
    if [ -n "$ZSH_VERSION" ]; then fixIndex=1; else fixIndex=0; fi; \
    local fortune=$(fortune -a -c ${@}); \
    local title=$(echo -e "$fortune" | head -1 | sed 's/[()]//g; s|\/usr\/share\/games\/fortunes\/||g'); \
    local text=$(echo -e "$fortune" | tail -n +3); \
    local cowBin=( cowsay cowthink ); \
    cowBin=${cowBin[ $RANDOM % ${#cowBin[@]} + ${fixIndex} ]}; \
    if [[ "${title}" =~ "^(knghtbrd|bofh-excuses|computers|debian-hints|linux|linuxcookie|mario.computadores|ubuntu-server-tips|de/computer|de/ms)" ]]; then \
        echo "${title}"; \
        echo "${text}" | ${cowBin} -n -f tux | lolcat; \
    elif [[ "${title}" =~ "^(definitions|mario.anagramas|platitudes|wisdom|de/murphy|de/sprichworte|de/sprichwortev|de/sprueche|de/unfug|de/wusstensie)" ]]; then \
        echo "${title}"; \
        local box=( columns parchment ); \
        box=${box[ $RANDOM % ${#box[@]} + ${fixIndex} ]}; \
        width=72; \
        if [[ "$box" == "columns" ]]; then width=66; fi; \
        echo "${text}" | fold -s -w $width | boxes -d ${box} | lolcat; \
    elif [[ "${title}" =~ "^(medicine|men-women|people)" ]]; then \
        echo "${title}"; \
        local box=( boy capgirl face girl santa ian_jones peek ); \
        box=${box[ $RANDOM % ${#box[@]} + ${fixIndex} ]}; \
        echo "${text}" | fold -s -w 76 | boxes -d ${box} | lolcat; \
    elif [[ "${title}" =~ "^(de/anekdoten|de/sicherheitshinweise)" ]]; then \
        echo "${title}"; \
        echo "${text}" | fold -s -w 76| ${cowBin} -n -f milk | lolcat; \
    elif [[ "${title}" =~ "^(de/mathematiker|de/stilblueten|de/witze)" ]]; then \
        echo "${title}"; \
        echo "${text}" | fold -s -w 76 | boxes -d nuke | lolcat; \
    elif [[ "${title}" =~ "^off/" ]]; then \
        echo "${title}"; \
        echo "${text}" | fold -s -w 76 | ${cowBin} -n -f eyes | lolcat; \
    else \
        echo "${text}" | fold -s -w 76 | boxes -d boxquote | sed "s|\[  \]|[${title}]|" | lolcat; \
    fi; \
}
randomFortuneChosen computers de/computer
```

### Create own fortune cookies

```bash
mkdir -p ~/.config/fortune
gedit ~/.config/fortune/quotes
```

~/.config/fortune/quotes:

```text
Quote1
%
Quote2
Quote2
%
Quote3
```

Generate *.dat file:

```bash
strfile -c % ~/.config/fortune/quotes ~/.config/fortune/quotes.dat

fortune ~/.config/fortune
fortune ~/.config/fortune/quotes
```
