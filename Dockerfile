# Use the official Dograh image from ghcr.io
FROM ghcr.io/dograh-hq/dograh:latest

# Set working directory
WORKDIR /app

# Expose ports for UI, API, and WebSocket
EXPOSE 3010 3011 3012

# Set environment variables
ENV NODE_ENV=production
ENV ENABLE_TELEMETRY=true
ENV PORT=3010

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3010/health || exit 1

# The base image already has an entrypoint, but we ensure it starts the service
CMD ["node", "server.js"]
