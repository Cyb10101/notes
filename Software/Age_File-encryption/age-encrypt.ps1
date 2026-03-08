$binAge=$(if (Test-Path "$PSScriptRoot\bin\age.exe") {"$PSScriptRoot\bin\age"} else {"age"})
$binFzf=$(if (Test-Path "$PSScriptRoot\bin\fzf.exe") {"$PSScriptRoot\bin\fzf"} else {"fzf"})
$binJq=$(if (Test-Path "$PSScriptRoot\bin\jq.exe") {"$PSScriptRoot\bin\jq"} else {"jq"})
$userConfig=$(if (Test-Path "$PSScriptRoot\config\users.json") {"$PSScriptRoot\config\users.json"} else {"$env:USERPROFILE\.config\age\users.json"})

if ($args.Count -eq 0) {
  Write-Host "Usage: $(Split-Path -Leaf $PSCommandPath) <file/folder>..."; exit 1
}

# Select recipients
$users = & $binJq -r '.[] | ""\(.name) [\(.groups)]""' $userConfig | & $binFzf -m --layout=reverse --prompt="Recipients: "
if (-not $users) {
  Write-Host "Aborted"; exit 1
}

# Extract keys
$recipients = @(
  # "-r" "age1key"
)
$lines = $users -split "`n"
foreach ($line in $lines) {
  $user = $line -replace " \[[^]]*\]$", ""
  $key = & $binJq -r --arg sel "$user" '.[] | select(.name == $sel) | .key' $userConfig
  $recipients += @("-r", $key)
}

# Encrypt
$tmpZip = "$env:TEMP\tmp.zip"
foreach ($file in $args) {
  $file = (Resolve-Path $file).ProviderPath
  $file = $file.TrimEnd('\', '/')
  if (Test-Path $tmpZip) {
    Remove-Item $tmpZip
  }

  if (!(Test-Path $file)) {
    Write-Host "Error - File not found: $file"; continue
  } elseif ((Get-Item $file).PSIsContainer) {
    Compress-Archive -Path $file -DestinationPath $tmpZip -Force
    & $binAge @recipients -o "$(Split-Path -Leaf $file).zip.age" $tmpZip
  } else {
    & $binAge @recipients -o "$(Split-Path -Leaf $file).age" $file
  }

  if ($LASTEXITCODE -eq 0) {
    if (!(Test-Path $file)) {
      Remove-Item $tmpZip
    }
    Write-Host "Encrypted: $file"
  } else {
    Write-Host "Not encrypted: $file"
  }
}
