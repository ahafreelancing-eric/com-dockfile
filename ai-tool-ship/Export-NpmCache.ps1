[CmdletBinding()]
param(
    [string] $Image = "dengfuyuan84/ai-tool-ship:latest",
    [string] $Destination = (Join-Path (Split-Path -Parent $PSCommandPath) "exported-npm-cache")
)

$ErrorActionPreference = "Stop"
$containerName = "ai-tool-ship-export-" + [guid]::NewGuid().ToString("N")

if (Test-Path -LiteralPath $Destination) {
    throw "Destination already exists: $Destination. Choose a new -Destination path."
}

try {
    docker create --name $containerName $Image | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "docker create failed with exit code $LASTEXITCODE." }

    # Copy the cache directory itself, preserving npm's expected _cacache layout.
    docker cp "${containerName}:/npm-cache" $Destination
    if ($LASTEXITCODE -ne 0) { throw "docker cp failed with exit code $LASTEXITCODE." }
}
finally {
    docker rm -f $containerName 2>$null | Out-Null
}

Write-Host "Cache exported to: $Destination"
Write-Host "Use it with: npm install --offline --cache `"$Destination`" <package>"
