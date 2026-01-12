# generate-web-data.ps1
# Generates the JavaScript data for web/index.html from the agents/ directory

$ErrorActionPreference = "Stop"

$basePath = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not $basePath) { $basePath = (Get-Location).Path }
$agentsPath = Join-Path $basePath "agents"

# Category to platform mapping
$categoryPlatform = @{
    "_global" = "multi"
    "architecture" = "multi"
    "backend" = "cloud"
    "data" = "cloud"
    "devops" = "cloud"
    "docs" = "multi"
    "integrations" = "multi"
    "operations" = "cloud"
    "platform-cloud" = "cloud"
    "platform-desktop" = "desktop"
    "platform-mobile" = "mobile"
    "platform-web" = "web"
    "process" = "multi"
    "product" = "multi"
    "quality" = "multi"
    "security" = "cloud"
    "testing" = "multi"
}

# Get all agent files
$agentFiles = Get-ChildItem -Path $agentsPath -Recurse -Filter "*.agent.txt"

Write-Host "Found $($agentFiles.Count) agent files"

$agents = @()

foreach ($file in $agentFiles) {
    $category = $file.Directory.Name
    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # Extract agent name from first line (AGENTE: Name)
    $firstLine = ($content -split "`n")[0]
    if ($firstLine -match "^AGENTE:\s*(.+)$") {
        $name = $Matches[1].Trim()
    } else {
        # Fallback to filename
        $name = [System.IO.Path]::GetFileNameWithoutExtension($file.Name) -replace "\.agent$", ""
        $name = ($name -split "-" | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_) }) -join " "
        $name = "$name Agent"
    }

    # Escape backticks and dollar signs for JavaScript template literal
    $escapedContent = $content -replace '`', '\`' -replace '\$', '\$'

    $platform = $categoryPlatform[$category]
    if (-not $platform) { $platform = "multi" }

    $agents += @{
        name = $name
        pack = "v3.0"
        category = $category
        platform = $platform
        path = "agents/$category/$($file.Name)"
        config = $escapedContent
    }
}

# Sort by category then name
$agents = $agents | Sort-Object { $_.category }, { $_.name }

# Generate JavaScript
$jsOutput = @"
        const agents = [
"@

foreach ($agent in $agents) {
    $configEscaped = $agent.config -replace "'", "\'" -replace "`r`n", "`n"
    $jsOutput += @"

            { name: '$($agent.name)', pack: '$($agent.pack)', category: '$($agent.category)', platform: '$($agent.platform)', path: '$($agent.path)', config: ``$($agent.config)`` },
"@
}

$jsOutput += @"

        ];
"@

# Output to file
$outputPath = Join-Path $basePath "scripts\agents-data.js"
$jsOutput | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host "Generated agents data to: $outputPath"
Write-Host "Total agents: $($agents.Count)"
