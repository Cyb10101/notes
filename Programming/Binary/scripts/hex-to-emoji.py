#!/usr/bin/env python3
# Based on https://www.windytan.com/2014/10/visualizing-hex-bytes-with-unicode-emoji.html
# sudo install ~/Sync/notes/Programming/Binary/scripts/hex-to-emoji.py /usr/local/bin/hex-to-emoji
# printf 'ced2\nce:d9:22:11:00:b2:87:1d:51:01:ee:1d:20:2c:91:d1\n' | ./hex-to-emoji.py

import re
import sys
import os

emojis = [
    "🌀", "🌂", "🌅", "🌈", "🌙", "🌞", "🌟", "🌠", "🌰", "🌱", "🌲", "🌳", "🌴", "🌵", "🌷", "🌸",
    "🌹", "🌺", "🌻", "🌼", "🌽", "🌾", "🌿", "🍀", "🍁", "🍂", "🍃", "🍄", "🍅", "🍆", "🍇", "🍈",
    "🍉", "🍊", "🍋", "🍌", "🍍", "🍎", "🍏", "🍐", "🍑", "🍒", "🍓", "🍔", "🍕", "🍖", "🍗", "🍘",
    "🍜", "🍝", "🍞", "🍟", "🍠", "🍡", "🍢", "🍣", "🍤", "🍥", "🍦", "🍧", "🍨", "🍩", "🍪", "🍫",
    "🍬", "🍭", "🍮", "🍯", "🍰", "🍱", "🍲", "🍳", "🍴", "🍵", "🍶", "🍷", "🍸", "🍹", "🍺", "🍻",
    "🍼", "🎀", "🎁", "🎂", "🎃", "🎄", "🎅", "🎈", "🎉", "🎊", "🎋", "🎌", "🎍", "🎎", "🎏", "🎒",
    "🎓", "🎠", "🎡", "🎢", "🎣", "🎤", "🎥", "🎦", "🎧", "🎨", "🎩", "🎪", "🎫", "🎬", "🎭", "🎮",
    "🎯", "🎰", "🎱", "🎲", "🎳", "🎴", "🎵", "🎷", "🎸", "🎹", "🎺", "🎻", "🎽", "🎾", "🎿", "🏀",
    "🏁", "🏂", "🏃", "🏄", "🏆", "🏇", "🏈", "🏉", "🏊", "🐀", "🐁", "🐂", "🐃", "🐄", "🐅", "🐆",
    "🐇", "🐈", "🐉", "🐊", "🐋", "🐌", "🐍", "🐎", "🐏", "🐐", "🐑", "🐒", "🐓", "🐔", "🐕", "🐖",
    "🐗", "🐘", "🐙", "🐚", "🐛", "🐜", "🐝", "🐞", "🐟", "🐠", "🐡", "🐢", "🐣", "🐤", "🐥", "🐦",
    "🐧", "🐨", "🐩", "🐪", "🐫", "🐬", "🐭", "🐮", "🐯", "🐰", "🐱", "🐲", "🐳", "🐴", "🐵", "🐶",
    "🐷", "🐸", "🐹", "🐺", "🐻", "🐼", "🐽", "🐾", "👀", "👂", "👃", "👄", "👅", "👆", "👇", "👈",
    "👉", "👊", "👋", "👌", "👍", "👎", "👏", "👐", "👑", "👒", "👓", "👔", "👕", "👖", "👗", "👘",
    "👙", "👚", "👛", "👜", "👝", "👞", "👟", "👠", "👡", "👢", "👣", "👤", "👥", "👦", "👧", "👨",
    "👩", "👪", "👮", "👯", "👺", "👻", "👼", "👽", "👾", "👿", "💀", "💁", "💂", "💃", "💄", "💅"
]

def convertHexToEmoji(lines):
    appendEachRun = ''

    for line in lines:
        if not appendEachRun:
            appendEachRun = True
        else:
            print()

        print(line)

        # Remove characters, convert to lowercase
        line = line.replace(':', '').replace(" ", "").lower()

        lineEmojis = ''
        hexValues = [line[i:i+2] for i in range(0, len(line), 2)]
        for hexValue in hexValues:
            if not re.match(r'^[a-f0-9]{2}$', hexValue):
                print(f"Error hexadecimal mismatch: {hexValue}")
                exit(1)

            if lineEmojis:
                lineEmojis += ' '

            lineEmojis += emojis[int(hexValue, 16)]

        print(lineEmojis)

if not os.isatty(sys.stdin.fileno()):
    # Data is being piped to stdin
    inputData = sys.stdin.read()
    if inputData.strip():
        convertHexToEmoji(inputData.splitlines())
    else:
        print("No valid input given!")

# No data is being piped to stdin
elif len(sys.argv) > 1 and (os.path.isfile(sys.argv[1]) or os.path.islink(sys.argv[1])):
    #print(f"Filename specified: {sys.argv[1]}")
    with open(sys.argv[1], 'r') as file:
        convertHexToEmoji(file.read().splitlines())
elif len(sys.argv) > 1 and sys.argv[1] != '':
    #print(f"Input specified: {sys.argv[1]}")
    convertHexToEmoji(sys.argv[1].splitlines())
else:
    print("No valid input given!")
