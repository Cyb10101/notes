#!/usr/bin/env bash

textColor() {
    echo -e "\033[0;3${1}m${2}\033[0m"
}

setTitle() {
    echo -en "\033]0;${1}\a"
}

checkJava() {
    if ! command -v java > /dev/null; then
        textColor 3 'Install Java...'
        sudo apt -y install openjdk-21-jre
    fi
}

# Script #######################################################################
setTitle 'Minecraft - Server Console'

checkJava

# Accept eula
eulaMissing=0
if [ ! -f eula.txt ]; then
    eulaMissing=1
fi

#java -Xmx10G -jar paper-1.21.3-82.jar
java -Xmx4G -jar paper-1.21.3-82.jar
# java -Xms4G -Xmx4G -jar paper.jar --nogui

if [ -f eula.txt ] && [ $eulaMissing -eq 1 ]; then
    echo 'Automatically accepting eula... Please run again.'
    sed -i 's/^eula=false$/eula=true/' eula.txt
    sleep 10
fi
