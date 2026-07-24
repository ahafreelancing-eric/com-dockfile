[CmdletBinding()]
param(
    [string[]] $Packages = @(
        "opencode-ai",
        "@anthropic-ai/claude-code"
    ),
    [switch] $KeepExistingCache
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSCommandPath
$cacheDir = Join-Path $projectRoot "npm-cache"

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw "npm was not found. Install Node.js/npm first, then run this script again."
}

if ((Test-Path -LiteralPath $cacheDir) -and -not $KeepExistingCache) {
    Remove-Item -LiteralPath $cacheDir -Recurse -Force
}
New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null

# Installing to a temporary project makes npm fetch every direct and transitive
# package into the portable cache directory. --ignore-scripts avoids executing
# package lifecycle scripts on the cache-building Windows host.
$tempProject = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-tool-ship-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempProject | Out-Null

try {
    Push-Location $tempProject
    npm install --cache $cacheDir --package-lock=false --ignore-scripts --no-audit --no-fund @Packages
    if ($LASTEXITCODE -ne 0) {
        throw "npm install failed with exit code $LASTEXITCODE."
    }

    npm cache verify --cache $cacheDir
    if ($LASTEXITCODE -ne 0) {
        throw "npm cache verify failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
    Remove-Item -LiteralPath $tempProject -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "Cache created: $cacheDir"
Write-Host "Packages cached: $($Packages -join ', ')"
