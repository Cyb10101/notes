#!/usr/bin/env bash

if [ "$#" -eq 0 ]; then
  echo "Usage: $(basename "$0") <file/folder>..."; exit 1
fi

identityPaths=(
  ~/.config/age/keys.txt
  ~/.ssh/id_rsa
)

keys=(
  # "-i" "my-key"
)
for path in "${identityPaths[@]}"; do
  if [[ -f "$path" ]]; then
    keys+=("-i" "$path")
  fi
done

for file in ${@}; do
  echo "Decrypting: $file"
  if [ ! -f "$file" ]; then
    echo "❌ File not found: $file"; continue
  elif [[ "$file" == *.zip.age ]]; then
    age -d "${keys[@]}" -o tmp.zip "$file"
    unzip -q tmp.zip -d "${file%.zip.age}"
    rm tmp.zip
  else
    age -d "${keys[@]}" -o "${file%.age}" "$file"
  fi
done
