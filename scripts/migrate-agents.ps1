#!/usr/bin/env pwsh
# Script de migración de agentes a nueva estructura centralizada

$baseDir = "c:\Users\Machine\Documents\Proyect_IA\Agentic_configurations\Agentic_configurations"
$sourceDir = "$baseDir\Agentes_Claude_Code_Pack_v2_5_ULTRA\agents"
$targetDir = "$baseDir\agents"

# Mapeo de carpetas origen -> destino
$folderMapping = @{
    "global" = "_global"
    "web" = "platform-web"
    "mobile" = "platform-mobile"
    "desktop" = "platform-desktop"
    "cloud" = "platform-cloud"
    "backend" = "backend"
    "architecture" = "architecture"
    "devops" = "devops"
    "security" = "security"
    "testing" = "testing"
    "data" = "data"
    "integrations" = "integrations"
    "transversal" = "transversal-temp"  # Se redistribuirán después
}

# Función para convertir nombre a kebab-case
function ConvertTo-KebabCase {
    param([string]$name)

    # Quitar " Agent.txt" del final
    $name = $name -replace " Agent\.txt$", ""

    # Convertir a minúsculas y reemplazar espacios y & con guiones
    $name = $name.ToLower()
    $name = $name -replace " & ", "-"
    $name = $name -replace " ", "-"
    $name = $name -replace "--", "-"

    return "$name.agent.txt"
}

# Registro de agentes ya copiados (para evitar duplicados)
$copiedAgents = @{}

# Procesar cada carpeta
foreach ($folder in (Get-ChildItem -Path $sourceDir -Directory)) {
    $sourceFolderName = $folder.Name
    $targetFolderName = $folderMapping[$sourceFolderName]

    if (-not $targetFolderName) {
        Write-Host "Carpeta no mapeada: $sourceFolderName" -ForegroundColor Yellow
        continue
    }

    $targetPath = "$targetDir\$targetFolderName"

    # Crear carpeta destino si no existe
    if (-not (Test-Path $targetPath)) {
        New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
    }

    # Copiar archivos .txt (excepto index.txt)
    foreach ($file in (Get-ChildItem -Path $folder.FullName -Filter "*.txt")) {
        if ($file.Name -eq "index.txt") { continue }

        $newName = ConvertTo-KebabCase -name $file.Name

        # Solo copiar si no es duplicado
        if (-not $copiedAgents.ContainsKey($newName)) {
            $destFile = "$targetPath\$newName"
            Copy-Item -Path $file.FullName -Destination $destFile
            $copiedAgents[$newName] = $file.FullName
            Write-Host "Copiado: $($file.Name) -> $targetFolderName\$newName" -ForegroundColor Green
        } else {
            Write-Host "Duplicado ignorado: $($file.Name)" -ForegroundColor Gray
        }
    }
}

Write-Host ""
Write-Host "Total de agentes únicos copiados: $($copiedAgents.Count)" -ForegroundColor Cyan

# Ahora redistribuir los transversales a las carpetas correctas
$transversalDir = "$targetDir\transversal-temp"
if (Test-Path $transversalDir) {
    $redistribution = @{
        "bug-hunter.agent.txt" = "quality"
        "refactor-code-quality.agent.txt" = "quality"
        "performance-efficiency.agent.txt" = "quality"
        "quality-gatekeeper.agent.txt" = "quality"
        "code-review.agent.txt" = "quality"
        "technical-debt.agent.txt" = "quality"
        "test-strategy.agent.txt" = "testing"
        "technology-critic-improvement.agent.txt" = "process"
        "release-manager.agent.txt" = "operations"
        "docs-knowledge.agent.txt" = "docs"
        "design-system-steward.agent.txt" = "product"
        "license-reviewer-oss-alternatives.agent.txt" = "security"
        "api-design.agent.txt" = "process"
        "compliance.agent.txt" = "security"
        "i18n.agent.txt" = "product"
        "migration.agent.txt" = "process"
        "technology-radar.agent.txt" = "process"
        "idea-improver.agent.txt" = "process"
        "adr.agent.txt" = "docs"
        "onboarding.agent.txt" = "docs"
        "feature-flag.agent.txt" = "process"
        "logging-strategy.agent.txt" = "process"
        "error-handling.agent.txt" = "process"
        "configuration-management.agent.txt" = "process"
        "data-analytics.agent.txt" = "data"
    }

    foreach ($file in (Get-ChildItem -Path $transversalDir -Filter "*.txt")) {
        $targetFolder = $redistribution[$file.Name]
        if ($targetFolder) {
            $destPath = "$targetDir\$targetFolder"
            if (-not (Test-Path "$destPath\$($file.Name)")) {
                Move-Item -Path $file.FullName -Destination $destPath -Force
                Write-Host "Redistribuido: $($file.Name) -> $targetFolder" -ForegroundColor Blue
            }
        }
    }

    # Eliminar carpeta temporal si está vacía
    $remaining = Get-ChildItem -Path $transversalDir
    if ($remaining.Count -eq 0) {
        Remove-Item -Path $transversalDir -Force
    }
}

Write-Host ""
Write-Host "Migración completada!" -ForegroundColor Green
