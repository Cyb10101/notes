#!/usr/bin/env bash
# sudo install ~/Sync/notes/System/Linux/Scripts/jq-repl.sh /usr/local/bin/jq-repl

if [[ -z ${1} ]] || [[ ${1} == '-' ]]; then
    input=$(mktemp /tmp/jq-repl_XXXXXXXX)
    #trap 'rm -f "$input"' EXIT
    trap 'rm "$input"' EXIT
    cat /dev/stdin > "${input}"
else
    input=${1}
fi
echo '' | fzf --disabled --preview-window='up:90%' --print-query --preview "jq --color-output -r {q} ${input}"
