<# Title: Trading Paints Cleaner | Author: Max Soler | Date: January 20, 2026 #>

$iRacingIds = @(
    "753650",  # Max's ID
    "875749",  # Dad's iRacing ID
    "307657"   # PGT's iRacing ID
)
$escapeIds = $iRacingIds.ForEach({[Regex]::Escape($_)}) # MS Learn ref: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.5
$documents = [Environment]::GetFolderPath("MyDocuments")
$paints = Join-Path -Path $documents -ChildPath "iRacing\paint"

if (-not(Test-Path $paints)) {
    #Write-Host "iRacing\paint directory not found."
    exit
}

$files = @()
$files += gci -Path $paints -File -Filter "*.tga" -ea SilentlyContinue
gci -path $paints -Directory -ea SilentlyContinue | foreach {
    $files += gci -Path $_.FullName -File -Filter "*.tga" -ea SilentlyContinue
}

$regex = $escapeIds -join "|"
$delete = $files | where {$_.Name -notmatch $regex}

if (-not $delete) {
    #Write-Host "No paints to delete."
    exit
}

foreach ($file in $delete) {
    rm -Path $file.FullName -Force -ea SilentlyContinue
}