# AI Tool Ship: portable npm cache

This directory creates a very small Linux image which carries an npm content-addressed cache for OpenCode and Claude Code. It is a transport image only: it does not contain Node.js, OpenCode, or Claude Code.

## 1. Build the cache on a Windows machine with internet access

Requirements: Node.js/npm and Docker Desktop.

Run PowerShell from this directory:

```powershell
.\Download-NpmCache.ps1
.\Build-CacheImage.ps1
```

The default packages are `opencode-ai` and `@anthropic-ai/claude-code` (the official npm packages for OpenCode and Claude Code). To cache different package specs or versions:

```powershell
.\Download-NpmCache.ps1 -Packages "opencode-ai@latest", "@anthropic-ai/claude-code@latest"
```

Publish `ai-tool-ship:npm-cache` to an image registry accessible by the destination Windows machines, or transfer it as an image archive:

```powershell
docker save --output ai-tool-ship-npm-cache.tar ai-tool-ship:npm-cache
```

## 2. Export on the destination Windows machine

Pull (or load) the image, then copy the cache out:

```powershell
docker pull <registry>/ai-tool-ship:npm-cache
.\Export-NpmCache.ps1 -Image <registry>/ai-tool-ship:npm-cache -Destination C:\npm-offline-cache
```

For an archive instead of a registry:

```powershell
docker load --input .\ai-tool-ship-npm-cache.tar
.\Export-NpmCache.ps1 -Destination C:\npm-offline-cache
```

## 3. Install offline

Use the exported directory as npm's cache:

```powershell
npm install --global --offline --cache C:\npm-offline-cache opencode-ai @anthropic-ai/claude-code
```

`--offline` causes npm to fail rather than access the network if an exact package version or dependency is absent. Build the cache with the same package specs, registry, npm version, and lockfile policy that the destination installation will use. Native/optional dependencies can also vary by Node.js version and Windows architecture; test the intended offline installation before distribution.

## Refreshing

Run `Download-NpmCache.ps1` again (without `-KeepExistingCache`) to create a clean refreshed cache, then rebuild and republish the image. Use `-KeepExistingCache` only when deliberately adding packages to an existing cache.
