#!/usr/bin/env bash
# sudo install ~/Sync/notes/System/Linux/Scripts/jq-repl.sh /usr/local/bin/jq-repl

# Tests
# echo '[{"project": "Test 1"}, {"project": "Test 2"}]' | ~/Sync/notes/System/Linux/Scripts/jq-repl.sh
# echo '[{"project": "Test 1"}, {"project": "Test 2"}]' | ~/Sync/notes/System/Linux/Scripts/jq-repl.sh -q '.[].project'
# ~/Sync/notes/System/Linux/Scripts/jq-repl.sh file.json
# ~/Sync/notes/System/Linux/Scripts/jq-repl.sh -q '.[].project' file.json

args=()
query='.'
while [[ $# -gt 0 ]]; do
    case "$1" in
        -q|--query)
            query="$2"
            shift 2
        ;;
        *)
            args+=("$1")
            shift
        ;;
    esac
done

if [[ ( ${#args[@]} -eq 0 || ${#args[@]} -eq 1 ) && ( -z "${args[0]}" || ${args[0]} == '-' ) ]]; then
    input=$(mktemp /tmp/jq-repl_XXXXXXXX)
    #trap 'rm -f "$input"' EXIT
    trap 'rm "$input"' EXIT
    cat /dev/stdin > "$input"
else
    input="${args[@]}"
fi

getQuery=$(echo '' | fzf --disabled --preview-window='up:90%' --query="$query" --print-query --preview "jq --color-output -r {q} ${input}")
jq "$getQuery" "${input}"
