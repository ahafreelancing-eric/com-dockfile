FROM alpine:3.22

LABEL org.opencontainers.image.title="ai-tool-ship npm cache" \
      org.opencontainers.image.description="Offline npm cache for OpenCode and Claude Code"

# Keep the image intentionally minimal: it is a transport container, not a
# runtime image.  Consumers copy this directory out with `docker cp`.
COPY npm-cache/ /npm-cache/
CMD ["sh", "-c", "echo 'npm cache is available at /npm-cache' && du -sh /npm-cache"]
