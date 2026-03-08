$binAge=$(if (Test-Path "$PSScriptRoot\bin\age.exe") {"$PSScriptRoot\bin\age"} else {"age"})

if ($args.Count -eq 0) {
  Write-Host "Usage: $(Split-Path -Leaf $PSCommandPath) <file>..."; exit 1
}

$identityPaths = @(
  "$env:USERPROFILE\.config\age\keys.txt",
  "$env:USERPROFILE\.ssh\id_rsa"
)

$keys = @(
  # "-i" "my-key"
)
foreach ($path in $identityPaths) {
  if (Test-Path $path) {
    $keys += "-i", $path
  }
}

$tmpZip = "$env:TEMP\tmp.zip"
foreach ($file in $args) {
  Write-Host "Decrypting: $file"
  if (!(Test-Path $file)) {
    Write-Host "Error - not found: $file"; continue
  } elseif ($file -like '*.zip.age') {
    & $binAge -d @keys -o $tmpZip $file
    if ($LASTEXITCODE -eq 0) {
      Expand-Archive -Path $tmpZip -DestinationPath .\
      Remove-Item $tmpZip
    } else {
      Write-Host "Not extracted: $file"
    }
  } else {
    & $binAge -d @keys -o ((Split-Path -Leaf $file) -replace '\.age$', '') $file
  }
}
