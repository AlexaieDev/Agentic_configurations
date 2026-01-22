# extract-agents-from-html.ps1
# Extracts agent configurations from web/index.html to separate .agent.txt files

$ErrorActionPreference = "Stop"

# Use relative paths from script location
$basePath = Split-Path -Parent $PSScriptRoot
if (-not $basePath -or -not (Test-Path $basePath)) {
    $basePath = (Get-Location).Path
}

$htmlPath = Join-Path $basePath "web\index.html"
$agentsPath = Join-Path $basePath "agents"

Write-Host "Reading HTML from: $htmlPath"
$htmlContent = Get-Content $htmlPath -Raw -Encoding UTF8

# Categories to extract
$categories = @('languages', 'migrations', 'legacy-maintenance')

foreach ($category in $categories) {
    Write-Host "`nProcessing category: $category"

    # Create category folder if it doesn't exist
    $categoryPath = Join-Path $agentsPath $category
    if (-not (Test-Path $categoryPath)) {
        New-Item -ItemType Directory -Path $categoryPath -Force | Out-Null
        Write-Host "  Created folder: $categoryPath"
    }

    # Pattern to match agents in this category
    # Match: { name: 'Name Agent', pack: 'v2.5', category: 'category', platform: 'platform', config: `...` }
    $pattern = "\{\s*name:\s*'([^']+)',\s*pack:\s*'[^']+',\s*category:\s*'$category',\s*platform:\s*'[^']+',\s*config:\s*``([^``]+)``\s*\}"

    $matches = [regex]::Matches($htmlContent, $pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

    Write-Host "  Found $($matches.Count) agents"

    foreach ($match in $matches) {
        $agentName = $match.Groups[1].Value
        $agentConfig = $match.Groups[2].Value

        # Generate filename from agent name
        # Remove " Agent" suffix, convert to kebab-case
        $fileName = $agentName -replace '\s+Agent$', ''
        $fileName = $fileName -replace '[/\.]', '-'
        $fileName = $fileName -replace '\s+', '-'
        $fileName = $fileName.ToLower()
        $fileName = "$fileName.agent.txt"

        $filePath = Join-Path $categoryPath $fileName

        # Write the config to file
        $agentConfig | Out-File -FilePath $filePath -Encoding UTF8 -NoNewline

        Write-Host "    Extracted: $agentName -> $fileName"
    }
}

Write-Host "`nDone! Checking results..."

# Count extracted agents
$totalExtracted = 0
foreach ($category in $categories) {
    $categoryPath = Join-Path $agentsPath $category
    $count = (Get-ChildItem -Path $categoryPath -Filter "*.agent.txt" -ErrorAction SilentlyContinue | Measure-Object).Count
    Write-Host "$category : $count agents"
    $totalExtracted += $count
}
Write-Host "Total extracted: $totalExtracted"
