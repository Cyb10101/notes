if ($args.Count -eq 0) {
  Write-Host "Usage: $(Split-Path -Leaf $PSCommandPath) <file.age>..."; exit 1
}

$identityPaths = @(
  "$env:USERPROFILE\.config\age\keys.txt",
  "$env:USERPROFILE\.ssh\id_rsa"
)

$keys = @()
foreach ($path in $identityPaths) {
  if (Test-Path $path) {
    $keys += "-i", $path
  }
}

foreach ($inputFile in $args) {
  if (-not (Test-Path $inputFile)) {
    Write-Host "Error - not found: $inputFile"; continue
  }

  if ($inputFile -notlike '*.age') {
    Write-Host "Unsupported file type: $inputFile"; continue
  }

  # Decrypt
  $outputPath = Split-Path -Leaf ($inputFile -replace '\.age$', '')
  & age -d @keys -o $outputPath $inputFile
  if ($LASTEXITCODE -ne 0) {
    Write-Host "Not decrypted: $inputFile"; continue
  }

  if ($outputPath -notlike '*.zip') {
    Write-Host "Decrypted: $outputPath"; continue
  }

  # Extract
  $destination = Split-Path -Leaf ($outputPath -replace '\.zip$', '')
  if ((Test-Path $destination) -and (-not (Get-Item $destination).PSIsContainer)) {
    Write-Host "Extraction target exists and is not a directory: $destination"; continue
  }

  & unzip -q $outputPath -d $destination | Out-Null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "Archive extraction failed: $inputFile"
  }

  if (Test-Path $outputPath) {
    Remove-Item $outputPath
  } else {
    Write-Host "Cleanup warning! Extracted archive not found: $outputPath"
  }
  Write-Host "Decrypted and extracted: $destination"
}
