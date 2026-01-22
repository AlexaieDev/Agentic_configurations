# update-html-agents.ps1
# Replaces the agents array in index.html with data from agents-data.js

$ErrorActionPreference = "Stop"
$basePath = Split-Path -Parent $PSScriptRoot
if (-not $basePath) { $basePath = (Get-Location).Path }

$htmlPath = Join-Path $basePath "web\index.html"
$agentsDataPath = Join-Path $basePath "scripts\agents-data.js"

Write-Host "Reading index.html..."
$htmlLines = Get-Content $htmlPath -Encoding UTF8

Write-Host "Reading agents-data.js..."
$agentsData = Get-Content $agentsDataPath -Raw -Encoding UTF8

# Find the agents array boundaries
# Line 2790 (index 2789): const agents = [
# Line 16528 (index 16527): ];

$startIndex = 2789  # const agents = [
$endIndex = 16527   # ];

Write-Host "Original lines: $($htmlLines.Length)"
Write-Host "Replacing lines $($startIndex + 1) to $($endIndex + 1)"

# Get parts
$firstPart = $htmlLines[0..($startIndex - 1)]
$lastPart = $htmlLines[($endIndex + 1)..($htmlLines.Length - 1)]

# Combine
$newContent = @()
$newContent += $firstPart
$newContent += $agentsData -split "`n"
$newContent += $lastPart

Write-Host "New total lines: $($newContent.Length)"

# Write back
$newContent | Set-Content $htmlPath -Encoding UTF8

Write-Host "Done! HTML updated successfully."
