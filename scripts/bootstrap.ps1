# Copy the shared pi extension into the Windows pi agent directory.
# Default is dry-run. Use -Apply to write.
param(
    [switch]$Apply
)

$ErrorActionPreference = "Stop"
$repo = Split-Path -Parent $PSScriptRoot
$src = Join-Path $repo "shared\pi\agent\extensions\wt-tabs.ts"
$dst = Join-Path $env:USERPROFILE ".pi\agent\extensions\wt-tabs.ts"

if (-not (Test-Path $src)) {
    throw "source not found: $src"
}

Write-Host "source: $src"
Write-Host "target: $dst"

if (-not $Apply) {
    Write-Host "dry-run only. Re-run with -Apply to copy."
    Write-Host ""
    Write-Host "Windows Terminal settings are not modified automatically; see windows\README.md."
    exit 0
}

$dstDir = Split-Path -Parent $dst
New-Item -ItemType Directory -Force $dstDir | Out-Null

if (Test-Path $dst) {
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $bak = "$dst.bak-$stamp"
    Copy-Item $dst $bak
    Write-Host "backup: $bak"
}

Copy-Item $src $dst -Force
Write-Host "copied: $src -> $dst"
Write-Host "Run /reload in an existing pi session, or start a new one."
