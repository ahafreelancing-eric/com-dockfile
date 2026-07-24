[CmdletBinding()]
param(
    [string] $Image = "ai-tool-ship:npm-cache"
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSCommandPath
$cacheDir = Join-Path $projectRoot "npm-cache"

if (-not (Test-Path -LiteralPath $cacheDir)) {
    throw "Cache directory not found: $cacheDir. Run .\Download-NpmCache.ps1 first."
}

docker build --tag $Image $projectRoot
if ($LASTEXITCODE -ne 0) {
    throw "docker build failed with exit code $LASTEXITCODE."
}

Write-Host "Created image: $Image"
