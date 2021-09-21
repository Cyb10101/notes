# Set-ExecutionPolicy RemoteSigned -scope CurrentUser -Confirm:$False -Force

# Muffet - Broken link checker
# https://github.com/raviqqe/muffet/releases/latest

class CybTools {
  [bool] fileExists($file) {
    return (Test-Path "$file" -PathType leaf)
  }

}
$tools = [CybTools]::new()

if (!$tools.fileExists("muffet.exe")) {
  Write-Host "Error: Muffet not found! https://github.com/raviqqe/muffet/releases/latest"
  exit
}

$filename = Read-Host 'Filename (example_www)'
$website = Read-Host 'Website (https://example.com/)'

if ($filename -eq "" -Or $website -eq "") {
  Write-Host "Error: Filename or Website empty!"
  exit
}

& .\muffet.exe /exclude:'^\/_error.*' /max-connections:200 /skip-tls-verification /json ${website} > ${filename}.json
