[CmdletBinding()]
param(
    [string]$DayFolder,
    [string]$CommitMessage,
    [switch]$NoPush
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $repoRoot

function Write-Info($message) {
    Write-Host "[auto_day_update] $message"
}

if (-not $DayFolder) {
    $dayFolders = Get-ChildItem -Path $repoRoot -Directory -Filter "Day-*" |
        Sort-Object LastWriteTime -Descending

    if ($dayFolders.Count -eq 0) {
        throw "No Day-* folder found in the repository."
    }

    $DayFolder = $dayFolders[0].Name
}

$folderPath = Join-Path $repoRoot $DayFolder
if (-not (Test-Path $folderPath)) {
    throw "Folder not found: $folderPath"
}

$folderMatch = [regex]::Match($DayFolder, '^Day-(\d{2})-(.+)$')
if (-not $folderMatch.Success) {
    throw "The Day folder name must follow the pattern Day-XX-Name, example: Day-08-New-Admin-Account-Created"
}

$dayNumber = $folderMatch.Groups[1].Value
$dayTitle = ($folderMatch.Groups[2].Value -replace '-', ' ')
$dayTitle = [System.Globalization.CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($dayTitle.ToLower())

$readmePath = Join-Path $repoRoot "README.md"
$readmeContent = Get-Content -Path $readmePath -Raw

$dayRowPattern = "| Day $dayNumber | .*? | .*? |"
$roadmapUpdated = $false

if ($readmeContent -match "^\| Day $([int]$dayNumber) \| .*\|.*\|") {
    $roadmapUpdated = $true
}

# Replace the relevant row with a completed marker
$pattern = "^\| Day $([int]$dayNumber) \| $([regex]::Escape($dayTitle)) \| .*? \|$"
$newLine = "| Day $([int]$dayNumber) | $dayTitle | ✅ Completed |"

$readmeContent = [regex]::Replace($readmeContent, $pattern, $newLine, [System.Text.RegularExpressions.RegexOptions]::Multiline)

if ($readmeContent -ne (Get-Content -Path $readmePath -Raw)) {
    Set-Content -Path $readmePath -Value $readmeContent -NoNewline
    Write-Info "Updated roadmap row for Day $dayNumber in the main README."
}

$gitStatusBefore = (& git status --porcelain)

# Stage only the selected new day folder and the main README update.
$gitAddFolder = "git add -- " + ("`"" + $DayFolder + "`"")
$gitAddReadme = "git add -- README.md"

& git add -- $DayFolder
& git add -- README.md

# If no tracked changes remain after stage, the script exits without creating a commit.
$gitStatusAfter = (& git status --porcelain)

if ($gitStatusAfter -match '^[? MARC][? ]|^A ') {
    # Commit message default if no custom message is supplied
    if (-not $CommitMessage) {
        $CommitMessage = "Add Day $([int]$dayNumber) $dayTitle documentation"
    }

    & git commit -m $CommitMessage
    Write-Info "Committed: $CommitMessage"

    if (-not $NoPush) {
        & git push origin HEAD
        Write-Info "Pushed branch to origin."
    }
}
else {
    Write-Info "No new staged documentation changes found for Day $DayFolder. README is already in the requested completed state."
}
