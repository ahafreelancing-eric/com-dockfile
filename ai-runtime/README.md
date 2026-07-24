# Ubuntu 22.04 Dev Image

This Docker image is based on Ubuntu 22.04 and includes common CLI tools, Azul Zulu JDK 21, Node.js 22, Git, Python 3, OpenCode, and Claude Code.

## Build

This Dockerfile defaults to `linux/amd64`, which is the usual Linux container platform on Windows Docker Desktop.

```bash
docker buildx build --platform linux/amd64 -t ubuntu22-dev-ai:linux-amd64 --load .
```

On macOS/Linux, you can also use:

```bash
./build-linux-amd64.sh
```

On Windows PowerShell:

```powershell
.\build-linux-amd64.ps1
```

Use `buildx`, not Docker's legacy builder. On Apple Silicon macOS, the legacy builder can ignore the requested platform and still produce an `arm64` image.

## Run

```bash
docker run --rm -it -v "$PWD:/workspace" ubuntu22-dev-ai:linux-amd64
```

On Windows PowerShell:

```powershell
docker run --rm -it -v "${PWD}:/workspace" ubuntu22-dev-ai:linux-amd64
```

## Move To Windows

Save the Linux amd64 image on macOS/Linux:

```bash
docker save -o ubuntu22-dev-ai-linux-amd64.tar ubuntu22-dev-ai:linux-amd64
```

Load it on Windows PowerShell:

```powershell
docker load -i .\ubuntu22-dev-ai-linux-amd64.tar
```

Copy the image tar file to the Windows machine, then load it with Docker.

## Verify

```bash
java -version
node --version
npm --version
git --version
python3 --version
ps --version
curl --version
ip -V
opencode --version
claude --version
```

Claude Code and OpenCode still need their normal runtime authentication/API configuration when you use them.
