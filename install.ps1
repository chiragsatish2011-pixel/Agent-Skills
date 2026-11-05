<#
.SYNOPSIS
    Antigravity & Claude Code Portable Skill Pack Installer
.DESCRIPTION
    Installs curated skills into your global Antigravity / Gemini configuration directory
    (~/.gemini/config/skills) or into a project's local workspace (.agents/skills).
.PARAMETER Scope
    'global' (default: installs to ~/.gemini/config/skills) or 'workspace' (installs to ./.agents/skills)
.PARAMETER TargetDir
    Optional custom destination path.
.EXAMPLE
    .\install.ps1 -Scope global
    .\install.ps1 -Scope workspace
#>
param (
    [ValidateSet("global", "workspace", "custom")]
    [string]$Scope = "global",
    
    [string]$TargetDir = ""
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " 🚀 Antigravity & AI Agent Skills - Portable Installer    " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$CurrentDir = $PSScriptRoot
if (-not $CurrentDir) { $CurrentDir = Get-Location }

# Determine destination directory
if ($TargetDir -ne "") {
    $DestDir = $TargetDir
} elseif ($Scope -eq "global") {
    $DestDir = Join-Path $env:USERPROFILE ".gemini\config\skills"
} else {
    $DestDir = Join-Path (Get-Location) ".agents\skills"
}

Write-Host "Target Installation Path: " -NoNewline
Write-Host "$DestDir" -ForegroundColor Yellow

if (-not (Test-Path $DestDir)) {
    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
    Write-Host "Created directory: $DestDir" -ForegroundColor Green
}

$Categories = @(
    "01-Productivity-and-Planning",
    "02-Memory-and-Knowledge",
    "03-Code-Quality-and-Review",
    "04-Design-and-Frontend",
    "05-Developer-Tools-and-Infra",
    "06-Fullstack-and-Replica",
    "07-Stitch-and-Creative"
)

$TotalCopied = 0

foreach ($cat in $Categories) {
    $catPath = Join-Path $CurrentDir $cat
    if (Test-Path $catPath) {
        Write-Host "`n📦 Installing Category: $cat" -ForegroundColor Magenta
        $skills = Get-ChildItem -Path $catPath -Directory
        foreach ($skill in $skills) {
            $destSkillPath = Join-Path $DestDir $skill.Name
            Copy-Item -Path $skill.FullName -Destination $destSkillPath -Recurse -Force
            Write-Host "  ✔ $($skill.Name)" -ForegroundColor Gray
            $TotalCopied++
        }
    }
}

# Also handle 08-Plugins-and-Bundles for global plugin directory
if ($Scope -eq "global") {
    $GlobalPluginsDir = Join-Path $env:USERPROFILE ".gemini\config\plugins"
    $BundlesDir = Join-Path $CurrentDir "08-Plugins-and-Bundles"
    if (Test-Path $BundlesDir) {
        Write-Host "`n🔌 Installing Plugins into $GlobalPluginsDir..." -ForegroundColor Magenta
        if (-not (Test-Path $GlobalPluginsDir)) {
            New-Item -ItemType Directory -Path $GlobalPluginsDir -Force | Out-Null
        }
        $plugins = Get-ChildItem -Path $BundlesDir -Directory
        foreach ($plugin in $plugins) {
            $destPluginPath = Join-Path $GlobalPluginsDir $plugin.Name
            Copy-Item -Path $plugin.FullName -Destination $destPluginPath -Recurse -Force
            Write-Host "  ✔ Plugin: $($plugin.Name)" -ForegroundColor Green
        }
    }
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host " ✨ Installation Complete! $TotalCopied Skills Installed.  " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "You can now prompt your AI Agent with any installed skill." -ForegroundColor White
Write-Host "Restart your IDE or agent session to ensure all skills are indexed." -ForegroundColor DarkGray
