# Ubuntu 22.04 Dev Image

This Docker image is based on Ubuntu 22.04 and includes common CLI tools, Azul Zulu JDK 21, Node.js 22, Git, Python 3, OpenCode, and Claude Code.

## Build

```bash
docker build -t ubuntu22-dev-ai .
```

## Run

```bash
docker run --rm -it -v "$PWD:/workspace" ubuntu22-dev-ai
```

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

## NPM Cache

The image keeps all npm cache generated during the global install step in:

```bash
/opt/npm-cache
```

Export the cache from a built image:

```bash
docker create --name ubuntu22-dev-ai-cache ubuntu22-dev-ai
docker cp ubuntu22-dev-ai-cache:/opt/npm-cache ./npm-cache
docker rm ubuntu22-dev-ai-cache
```

Reuse it on another computer:

```bash
docker run --rm -it \
  -v "$PWD/npm-cache:/opt/npm-cache" \
  -v "$PWD:/workspace" \
  ubuntu22-dev-ai
```

You can also point npm directly at that cache:

```bash
npm install --cache ./npm-cache <package-name>
```
