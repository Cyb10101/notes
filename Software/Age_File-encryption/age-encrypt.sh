#!/usr/bin/env bash
userConfig=~/.config/age/users.json

################################################################################
# Script
if [ "$#" -eq 0 ]; then
  echo "Usage: $(basename "$0") <file/folder>..."; exit 1
fi

# Select recipients
users=$(jq -r '.[] | "\(.name) [\(.groups)]"' $userConfig | fzf -m --layout=reverse --prompt="Recipients: ")
if [ -z "$users" ]; then
  echo "Aborted"; exit 1
fi

# Extract keys
recipients=(
  # "-r" "age1key"
)
while IFS= read -r line; do
  user=$(echo "$line" | sed -E 's/ \[[^]]*\]$//')
  recipients+=("-r" $(jq -r --arg sel "$user" '.[] | select(.name == $sel) | .key' $userConfig))
done <<< "$users"

# Encrypt
for file in ${@}; do
  file="${file%/}"
  if [ ! -f "$file" ] && [ ! -d "$file" ]; then
    echo "❌ File not found: $file"; continue
  elif [ -d "$file" ]; then
    zip -r -q - "$file" | age "${recipients[@]}" > "${file}.zip.age"
  else
    age "${recipients[@]}" "$file" > "$file.age"
  fi

  if [ $? -eq 0 ]; then
    echo "✅ Encrypted: $file"
  else
    echo "❌ Not encrypted: $file"
  fi
done

