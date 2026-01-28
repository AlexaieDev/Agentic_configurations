# build-web-ui.ps1
# Generates web/index.html by injecting agent data into the template
#
# IMPORTANT: This script uses a template-based approach to preserve all UI features.
# Only the agents array is regenerated - all other sections (wizard, workflows, kits, etc.) are preserved.
#
# For JavaScript string escaping, we use [System.Web.HttpUtility]::JavaScriptStringEncode()
# NEVER use manual regex escaping like -replace '\$', '\$' - it doesn't work for JS template literals!

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8

# Use relative paths from script location for portability
$basePath = Split-Path -Parent $PSScriptRoot
if (-not $basePath -or -not (Test-Path $basePath)) {
    $basePath = (Get-Location).Path
}
$agentsPath = Join-Path $basePath "agents"
$templatePath = Join-Path $basePath "web\index-template.html"
$outputPath = Join-Path $basePath "web\index.html"

# Validate template exists
if (-not (Test-Path $templatePath)) {
    Write-Error "Template file not found: $templatePath"
    Write-Error "Please ensure web/index-template.html exists with the __AGENTS_DATA_PLACEHOLDER__ marker."
    exit 1
}

# Category to platform mapping
$categoryPlatform = @{
    "_global" = "multi"
    "architecture" = "multi"
    "backend" = "cloud"
    "business" = "multi"
    "data" = "cloud"
    "design" = "multi"
    "devops" = "cloud"
    "discovery" = "multi"
    "docs" = "multi"
    "growth" = "multi"
    "integrations" = "multi"
    "languages" = "multi"
    "legacy-maintenance" = "multi"
    "migrations" = "multi"
    "operations" = "cloud"
    "planning" = "multi"
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

Write-Host "========================================"
Write-Host "  Agent Catalog Web UI Builder"
Write-Host "========================================"
Write-Host ""
Write-Host "Base path: $basePath"
Write-Host "Agents path: $agentsPath"
Write-Host "Template: $templatePath"
Write-Host "Output: $outputPath"
Write-Host ""

# Get all agent files
$agentFiles = Get-ChildItem -Path $agentsPath -Recurse -Filter "*.agent.txt"
Write-Host "Found $($agentFiles.Count) agent files"

# Build agents array
$agentsData = @()
foreach ($file in $agentFiles) {
    $category = $file.Directory.Name
    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # Extract agent name from first line (AGENTE: Name)
    $lines = $content -split "`n"
    $firstLine = $lines[0].Trim()
    if ($firstLine -match "^AGENTE:\s*(.+)$") {
        $name = $Matches[1].Trim()
    } else {
        # Fallback to filename
        $name = [System.IO.Path]::GetFileNameWithoutExtension($file.Name) -replace "\.agent$", ""
        $name = ($name -split "-" | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_) }) -join " "
        $name = "$name Agent"
    }

    $platform = $categoryPlatform[$category]
    if (-not $platform) { $platform = "multi" }

    $agentsData += @{
        name = $name
        category = $category
        platform = $platform
        path = "agents/$category/$($file.Name)"
        config = $content
    }
}

# Sort by category then name
$agentsData = $agentsData | Sort-Object { $_.category }, { $_.name }

Write-Host "Building JavaScript agents array..."

# Load System.Web for proper JavaScript string encoding
# This is the ONLY correct way to escape strings for JavaScript in PowerShell!
Add-Type -AssemblyName System.Web

# Generate JS agents array with proper escaping
$jsAgents = "const agents = [`n"
foreach ($agent in $agentsData) {
    # Use JavaScriptStringEncode for ALL user content
    # This properly handles: quotes, backslashes, newlines, template literals (${...}), etc.
    $escapedName = [System.Web.HttpUtility]::JavaScriptStringEncode($agent.name)
    $escapedConfig = [System.Web.HttpUtility]::JavaScriptStringEncode($agent.config)

    # CRITICAL: Escape </ as <\/ to prevent browser from interpreting </script>
    # as closing the script block. JavaScript interprets <\/ as </ correctly.
    # This is a standard practice for JS embedded in HTML.
    # Use .Replace() for literal replacement (not regex -replace)
    $escapedConfig = $escapedConfig.Replace('</', '<\/')

    # Build entry using string concatenation (NOT -f format operator!)
    # The -f operator interprets { } in content as format placeholders, breaking the output
    $jsAgents += '            { name: "' + $escapedName + '", pack: "v3.0", category: "' + $agent.category + '", platform: "' + $agent.platform + '", path: "' + $agent.path + '", config: "' + $escapedConfig + '" },' + "`n"
}
$jsAgents += "        ];"

Write-Host "Reading template..."

# Read the template
$template = Get-Content $templatePath -Raw -Encoding UTF8

# Verify placeholder exists
if (-not $template.Contains("// __AGENTS_DATA_PLACEHOLDER__")) {
    Write-Error "Template does not contain the placeholder marker: // __AGENTS_DATA_PLACEHOLDER__"
    Write-Error "Please ensure the template has this marker where the agents array should be injected."
    exit 1
}

Write-Host "Injecting agents data into template..."

# Replace placeholder with agents array
# CRITICAL: Use .Replace() method, NOT -replace operator!
# The -replace operator uses regex and interprets $ in the replacement string
# as backreferences, which breaks content containing $_ or similar patterns.
$output = $template.Replace("        // __AGENTS_DATA_PLACEHOLDER__", $jsAgents)

Write-Host "Writing output file..."

# Write to file with proper UTF-8 encoding (no BOM)
[System.IO.File]::WriteAllText($outputPath, $output, [System.Text.UTF8Encoding]::new($false))

Write-Host ""
Write-Host "========================================"
Write-Host "  BUILD COMPLETE"
Write-Host "========================================"
Write-Host ""
Write-Host "Generated: $outputPath"
Write-Host "Total agents embedded: $($agentsData.Count)"
Write-Host ""
Write-Host "IMPORTANT: After modifying this script, always test the web UI:"
Write-Host "  1. Open web/index.html in a browser"
Write-Host "  2. Open DevTools (F12) and check for JavaScript errors"
Write-Host "  3. Click on an agent to verify the modal shows correctly"
Write-Host "  4. Verify all sections work: Wizard, Workflows, Kits, Phases"
Write-Host ""
