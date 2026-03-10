#!/usr/bin/env bash
set -u

if [[ $# -eq 0 ]]; then
  echo "Usage: $(basename "$0") <file.age>..."; exit 1
fi

identity_paths=(
  "${XDG_CONFIG_HOME:-$HOME/.config}/age/keys.txt"
  "$HOME/.ssh/id_rsa"
)

keys=()
for path in "${identity_paths[@]}"; do
  if [[ -f "$path" ]]; then
    keys+=("-i" "$path")
  fi
done

for input_file in "$@"; do
  if [[ ! -f "$input_file" ]]; then
    echo "File not found: $input_file"; continue
  fi

  if [[ "$input_file" != *.age ]]; then
    echo "Unsupported file type: $input_file"; continue
  fi

  # Decrypt
  output_path="$(basename "${input_file%.age}")"
  if ! age -d "${keys[@]}" -o "$output_path" "$input_file"; then
    echo "Not decrypted: $input_file"; continue
  fi

  if [[ "$output_path" != *.zip ]]; then
    echo "Decrypted: $output_path"; continue
  fi

  # Extract
  destination="$(basename "${output_path%.zip}")"
  if [[ -e "$destination" && ! -d "$destination" ]]; then
    echo "Extraction target exists and is not a directory: $destination"; continue
  fi

  if ! unzip -q "$output_path" -d "$destination"; then
    echo "Archive extraction failed: $input_file"
  fi

  if [[ -f "$output_path" ]]; then
    rm "$output_path"
  else
    echo "Cleanup warning! Extracted archive not found: $output_path"
  fi
  echo "Decrypted and extracted: $destination"
done
