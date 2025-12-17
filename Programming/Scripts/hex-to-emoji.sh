#!/usr/bin/env bash
# Based on https://www.windytan.com/2014/10/visualizing-hex-bytes-with-unicode-emoji.html
# sudo install ~/Sync/notes/Programming/Binary/scripts/hex-to-emoji.sh /usr/local/bin/hex-to-emoji
# printf 'ced2\nce:d9:22:11:00:b2:87:1d:51:01:ee:1d:20:2c:91:d1\n' | ./hex-to-emoji.py

emojis=(
    🌀 🌂 🌅 🌈 🌙 🌞 🌟 🌠 🌰 🌱 🌲 🌳 🌴 🌵 🌷 🌸 \
    🌹 🌺 🌻 🌼 🌽 🌾 🌿 🍀 🍁 🍂 🍃 🍄 🍅 🍆 🍇 🍈 \
    🍉 🍊 🍋 🍌 🍍 🍎 🍏 🍐 🍑 🍒 🍓 🍔 🍕 🍖 🍗 🍘 \
    🍜 🍝 🍞 🍟 🍠 🍡 🍢 🍣 🍤 🍥 🍦 🍧 🍨 🍩 🍪 🍫 \
    🍬 🍭 🍮 🍯 🍰 🍱 🍲 🍳 🍴 🍵 🍶 🍷 🍸 🍹 🍺 🍻 \
    🍼 🎀 🎁 🎂 🎃 🎄 🎅 🎈 🎉 🎊 🎋 🎌 🎍 🎎 🎏 🎒 \
    🎓 🎠 🎡 🎢 🎣 🎤 🎥 🎦 🎧 🎨 🎩 🎪 🎫 🎬 🎭 🎮 \
    🎯 🎰 🎱 🎲 🎳 🎴 🎵 🎷 🎸 🎹 🎺 🎻 🎽 🎾 🎿 🏀 \
    🏁 🏂 🏃 🏄 🏆 🏇 🏈 🏉 🏊 🐀 🐁 🐂 🐃 🐄 🐅 🐆 \
    🐇 🐈 🐉 🐊 🐋 🐌 🐍 🐎 🐏 🐐 🐑 🐒 🐓 🐔 🐕 🐖 \
    🐗 🐘 🐙 🐚 🐛 🐜 🐝 🐞 🐟 🐠 🐡 🐢 🐣 🐤 🐥 🐦 \
    🐧 🐨 🐩 🐪 🐫 🐬 🐭 🐮 🐯 🐰 🐱 🐲 🐳 🐴 🐵 🐶 \
    🐷 🐸 🐹 🐺 🐻 🐼 🐽 🐾 👀 👂 👃 👄 👅 👆 👇 👈 \
    👉 👊 👋 👌 👍 👎 👏 👐 👑 👒 👓 👔 👕 👖 👗 👘 \
    👙 👚 👛 👜 👝 👞 👟 👠 👡 👢 👣 👤 👥 👦 👧 👨 \
    👩 👪 👮 👯 👺 👻 👼 👽 👾 👿 💀 💁 💂 💃 💄 💅
)

convertHexToEmoji() {
    readarray -t lines < <(echo "${@}")
    appendEachRun=''
    for line in "${lines[@]}"; do
        if [ -z "${appendEachRun}" ]; then
            appendEachRun='true'
        else
            echo
        fi
        echo "${line}"

        # Remove characters, convert to lowercase
        line=$(echo "${line}" | sed 's/[: ]//g'| tr '[:upper:]' '[:lower:]')

        lineEmojis=''
        hexValues=($(echo "${line}" | fold -w2))
        for hexValue in "${hexValues[@]}"; do
            if ! [[ ${hexValue} =~ ^[a-f0-9]{2}$ ]] ; then
                echo "Error hexadecimal missmatch: ${hexValue}";
                exit 1;
            fi

            if [ ! -z "${lineEmojis}" ]; then
                lineEmojis+=' ';
            fi
            lineEmojis+="${emojis[16#${hexValue}]}"
        done

        echo "${lineEmojis}"
    done
}

if [ -p /dev/stdin ]; then
  # If we want to read the input line by line
  #while IFS= read input; do echo "Pipe Line: ${input}"; done

  # Grab input to a variable
  input=`cat`
  if [[ ! -z "${input}" ]]; then
    convertHexToEmoji "${input}"
  else
    echo "No valid input given!"
  fi
elif [ -f "${1}" ] || [ -h "${1}" ]; then
  #echo "Filename specified: ${1}"
  convertHexToEmoji "$(cat "${1}")"
elif [ ! -z "${1}" ]; then
  #echo "Input specified: ${1}"
  convertHexToEmoji "${1}"
else
  echo "No valid input given!"
fi
