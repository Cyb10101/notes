$userConfigJson = "$env:USERPROFILE\.config\age\users.json"
$selector = "auto" # auto, gum, fzf

function Get-RandomAlphaNumeric {
  return -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 4 | ForEach-Object { [char]$_ })
}

function Get-UsersFromJson() {
  $users = @()
  $rows = & jq -r '.[] | (if (.groups // """") == """" then .name else ""\(.name) [\(.groups)]"" end) + ""\t"" + .key' $userConfigJson
  foreach ($row in ($rows -split "`n")) {
    if (-not $row) {
      continue
    }
    $parts = $row -split "`t", 2
    $users += [pscustomobject]@{
      key = [string]$parts[1]
      label = [string]$parts[0]
    }
  }
  return $users
}

function Select-Recipients([object[]]$Users) {
  $labels = $Users | ForEach-Object { $_.label }

  if ($selector -in @("auto", "gum") -and (Get-Command gum -ErrorAction SilentlyContinue)) {
    $selector = "gum"
  } elseif ($selector -in @("auto", "fzf") -and (Get-Command fzf -ErrorAction SilentlyContinue)) {
    $selector = "fzf"
  } else {
    throw "No selector found. Install gum or fzf."
  }

  if ($selector -eq "gum") {
    return & gum choose --no-limit @labels
  } elseif ($selector -eq "fzf") {
    return $labels | & fzf -m --layout=reverse --prompt="Recipients: "
  }
}

# Get input
$inputPaths = @($args)
if ($inputPaths.Count -eq 0) {
  Write-Host "Usage: $(Split-Path -Leaf $PSCommandPath) <file/folder>..."; exit 1
}

$archiveInputs = @()
$missingInputs = @()
foreach ($path in $inputPaths) {
  if (-not (Test-Path $path)) {
    $missingInputs += $path; continue
  }
  $archiveInputs += $path.TrimEnd('\', '/')
}

if ($missingInputs.Count -gt 0) {
  Write-Host "Missing input:"
  foreach ($path in $missingInputs) {
    Write-Host "* $path"
  }
  exit 1
}

# Get recipients
if (-not (Test-Path $userConfigJson)) {
  throw "No recipient config found. Expected users.json."
}

$users = Get-UsersFromJson
$selectedLabels = Select-Recipients $users
if (-not $selectedLabels) {
  Write-Host "Aborted"; exit 1
}

$recipients = @()
$selectedLookup = @{}
foreach ($line in ($selectedLabels -split "`n")) {
  if ($line) {
    $selectedLookup[$line] = $true
  }
}
foreach ($user in $users) {
  if ($selectedLookup.ContainsKey($user.label)) {
    $recipients += @("-r", $user.key)
  }
}

if ($recipients.Count -eq 0) {
  Write-Host "No recipients selected"; exit 1
}

# Create encrypted archive
$dateStamp = Get-Date -Format 'yyyy-MM-dd'
$suffix = Get-RandomAlphaNumeric
$baseName = "bundle_{0}_{1}.zip" -f $dateStamp, $suffix
$archivePath = Join-Path (Get-Location).Path $baseName
Write-Host "Creating archive: $baseName"
& zip -r -q $archivePath @archiveInputs | Out-Null
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $archivePath)) {
  Write-Host "Archive creation failed"; exit 1
}

try {
  & age @recipients -o "$baseName.age" $archivePath
  if ($LASTEXITCODE -ne 0) {
    Write-Host "Not encrypted: $($archiveInputs -join ', ')"
    exit 1
  }

  Write-Host "Encrypted: $baseName.age"
} finally {
  if ($archivePath) {
    if (Test-Path $archivePath) {
      Remove-Item $archivePath
    } else {
      Write-Host "Cleanup warning! Temporary archive not found: $archivePath"
    }
  }
}
