#!/bin/bash

# Dograh AI - Cloudflare Deployment Script
# This script automates the deployment of Dograh AI on a VPS with Cloudflare Tunnel

set -e

echo "🚀 Starting Dograh AI Cloudflare Deployment..."

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Install Docker
echo "📦 Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
else
    echo "✅ Docker already installed"
fi

# Install Docker Compose
echo "📦 Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    apt-get update
    apt-get install -y docker-compose-plugin
else
    echo "✅ Docker Compose already installed"
fi

# Clone the repository
echo "📂 Cloning dograh-cloudflare repository..."
cd /opt
if [ ! -d "dograh-cloudflare" ]; then
    git clone https://github.com/saikat-says-cool/dograh-cloudflare.git
    cd dograh-cloudflare
else
    cd dograh-cloudflare
    git pull
fi

# Start Dograh with Docker Compose
echo "🐳 Starting Dograh AI with Docker Compose..."
REGISTRY=ghcr.io/dograh-hq ENABLE_TELEMETRY=true docker compose up -d

echo "⏳ Waiting for Dograh to start..."
sleep 10

# Verify installation
echo "✅ Checking if Dograh is running..."
if curl -f http://localhost:3010 > /dev/null 2>&1; then
    echo "✅ Dograh AI is running on port 3010!"
else
    echo "❌ Failed to start Dograh. Check logs with: docker compose logs"
    exit 1
fi

# Install Cloudflared
echo "📦 Installing Cloudflared..."
if ! command -v cloudflared &> /dev/null; then
    apt-get update
    apt-get install -y cloudflared
else
    echo "✅ Cloudflared already installed"
fi

echo ""
echo "====================================="
echo "✅ Dograh AI is ready for deployment!"
echo "====================================="
echo ""
echo "Next steps:"
echo "1. Set up Cloudflare Tunnel (run as non-root user):"
echo "   cloudflared tunnel login"
echo "   cloudflared tunnel create dograh-ai"
echo ""
echo "2. Configure tunnel and routes"
echo "3. Start the tunnel: cloudflared tunnel run dograh-ai"
echo ""
echo "📖 For detailed instructions, see README.md"
echo "🌐 Access Dograh: https://dograh.YOUR_DOMAIN.com"
