$ImageName = if ($args.Count -ge 1) { $args[0] } else { "ubuntu22-dev-ai:linux-amd64" }

docker buildx version *> $null
if ($LASTEXITCODE -ne 0) {
  Write-Error "docker buildx is required to build a linux/amd64 image. Install Docker Buildx or use Docker Desktop, then run this script again."
  exit 1
}

docker buildx build `
  --platform linux/amd64 `
  -t $ImageName `
  --load `
  .
