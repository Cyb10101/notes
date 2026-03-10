#!/usr/bin/env bash
set -u

user_config_json="${XDG_CONFIG_HOME:-$HOME/.config}/age/users.json"
selector="auto" # auto, gum, fzf

load_users_json() {
  jq -r '.[] | (if (.groups // "") == "" then .name else "\(.name) [\(.groups)]" end) + "\t" + .key' "$user_config_json"
}

rand_alpha_numeric() {
  tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 4
}

select_recipients() {
  if [[ "$selector" == "auto" || "$selector" == "gum" ]] && command -v gum >/dev/null 2>&1; then
    selector="gum";
  elif [[ "$selector" == "auto" || "$selector" == "fzf" ]] && command -v fzf >/dev/null 2>&1; then
    selector="fzf";
  else
    echo "No selector found. Install gum or fzf." >&2; return 1
  fi

  if [[ "$selector" == "gum" ]]; then
    gum choose --no-limit "$@"
  elif [[ "$selector" == "fzf" ]]; then
    printf '%s\n' "$@" | fzf -m --layout=reverse --prompt="Recipients: "
  fi
}

if [[ $# -eq 0 ]]; then
  echo "Usage: $(basename "$0") <file/folder>..."; exit 1
fi

# Get input
resolved_inputs=()
missing_inputs=()
for path in "$@"; do
  if [[ ! -e "$path" ]]; then
    missing_inputs+=("$path"); continue
  fi
  resolved_inputs+=("${path%/}")
done

if [[ ${#missing_inputs[@]} -gt 0 ]]; then
  echo "Missing input:"
  for path in "${missing_inputs[@]}"; do
    echo "* $path"
  done
  exit 1
fi

# Get recipients
if [[ ! -f "$user_config_json" ]]; then
  echo "No recipient config found. Expected users.json."; exit 1
fi

user_rows="$(load_users_json)"
if [[ -z "$user_rows" ]]; then
  echo "Recipient config is empty."; exit 1
fi

labels=()
while IFS=$'\t' read -r label key; do
  [[ -z "$label" ]] && continue
  labels+=("$label")
done <<< "$user_rows"

selected_labels="$(select_recipients "${labels[@]}")"
if [[ -z "$selected_labels" ]]; then
  echo "Aborted"; exit 1
fi

recipients=()
while IFS=$'\t' read -r label key; do
  while IFS= read -r selected; do
    if [[ "$label" == "$selected" ]]; then
      recipients+=("-r" "$key")
      break
    fi
  done <<< "$selected_labels"
done <<< "$user_rows"

if [[ ${#recipients[@]} -eq 0 ]]; then
  echo "No recipients selected."; exit 1
fi

# Create encrypted archive
date_stamp="$(date +%Y-%m-%d)"
while :; do
  tmp_archive="./bundle_${date_stamp}_$(rand_alpha_numeric).zip"
  [[ ! -e "$tmp_archive" ]] && break
done
base_name="$(basename "${tmp_archive%.zip}").zip"
echo "Creating archive: $base_name"
zip -r -q "$tmp_archive" "${resolved_inputs[@]}" || {
  echo "Archive creation failed."; exit 1
}

cleanup() {
  if [[ -n "${tmp_archive:-}" ]]; then
    if [[ -f "$tmp_archive" ]]; then
      rm "$tmp_archive"
    else
      echo "Cleanup warning! Temporary archive not found: $tmp_archive" >&2
    fi
  fi
}
trap cleanup EXIT

if age "${recipients[@]}" -o "${base_name}.age" "$tmp_archive"; then
  echo "Encrypted: ${base_name}.age"
else
  echo "Not encrypted."; exit 1
fi
