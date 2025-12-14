# Dograh AI on Cloudflare

🎙️ Open Source Voice Agent Platform deployed on Cloudflare with Docker

## Overview

This repository contains the deployment configuration for **Dograh AI** - an open-source alternative to Vapi for building AI voice agents. This setup deploys Dograh on Cloudflare using Docker and Cloudflare Tunnel for reverse proxy.

## What is Dograh AI?

- **100% Open Source**: Self-hostable platform with no vendor lock-in
- **Voice Agent Platform**: Build AI-powered voice agents with a drag-and-drop interface
- **Full Control**: Every line of code is open - transparent and customizable
- **Privacy First**: Reduce latency and ensure data privacy with self-deployment
- **Multilingual**: Support for conversations in 30+ languages

## Deployment Architecture

```
┌─────────────┐
│  Your VPS   │
│  (Docker)   │
│ Dograh AI   │
└──────┬──────┘
       │ Port 3010
       ▼
┌─────────────────────────┐
│ Cloudflare Tunnel       │
│ (Reverse Proxy)         │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│ Cloudflare Network      │
│ (DDoS Protection, SSL)  │
└──────────┬──────────────┘
           │
           ▼
   Your Domain
```

## Prerequisites

- A VPS (DigitalOcean, Linode, AWS, etc.)
- Docker and Docker Compose installed
- A domain name
- Cloudflare account with your domain
- SSH access to your VPS

## Quick Start

### Step 1: SSH into your VPS

```bash
ssh root@YOUR_VPS_IP
```

### Step 2: Install Docker (if not already installed)

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

### Step 3: Clone this repository

```bash
git clone https://github.com/saikat-says-cool/dograh-cloudflare.git
cd dograh-cloudflare
```

### Step 4: Start Dograh with Docker Compose

```bash
REGISTRY=ghcr.io/dograh-hq ENABLE_TELEMETRY=true docker compose up -d
```

### Step 5: Verify Dograh is running

```bash
curl http://localhost:3010
```

You should see the Dograh UI HTML response.

### Step 6: Set up Cloudflare Tunnel

#### Install Cloudflared

```bash
sudo apt-get update
sudo apt-get install cloudflared
```

#### Authenticate

```bash
cloudflared tunnel login
```

This will open a browser to authenticate and download your credentials.

#### Create tunnel

```bash
cloudflared tunnel create dograh-ai
```

#### Note the tunnel ID from the output

#### Create config file

```bash
mkdir -p ~/.cloudflared
cat > ~/.cloudflared/config.yml << 'EOF'
tunnel: dograh-ai
credentials-file: /home/USERNAME/.cloudflared/TUNNEL_ID.json

ingress:
  - hostname: dograh.YOUR_DOMAIN.com
    service: http://localhost:3010
  - hostname: api.dograh.YOUR_DOMAIN.com
    service: http://localhost:3011
  - service: http_status:404
EOF
```

Replace:
- `USERNAME` with your username
- `TUNNEL_ID` with your tunnel ID
- `YOUR_DOMAIN.com` with your actual domain

#### Route DNS

```bash
cloudflared tunnel route dns dograh-ai dograh.YOUR_DOMAIN.com
cloudflared tunnel route dns dograh-ai api.dograh.YOUR_DOMAIN.com
```

#### Run tunnel

```bash
cloudflared tunnel run dograh-ai
```

#### (Optional) Run tunnel as service

```bash
sudo cloudflared service install
sudo systemctl restart cloudflared
```

### Step 7: Access Dograh

Visit `https://dograh.YOUR_DOMAIN.com` in your browser!

## Configuration

### Environment Variables

Edit `docker-compose.yaml` to customize:

```yaml
environment:
  - ENABLE_TELEMETRY=true  # Set to false to disable anonymous telemetry
  - NODE_ENV=production
```

### Persistent Storage

Data is stored in `./data` volume. Ensure it has sufficient space.

## Port Mappings

- **3010**: UI (main web interface)
- **3011**: API (backend API server)
- **3012**: WebSocket (real-time communication)

## Cloudflare Security Settings

1. Go to your domain settings in Cloudflare
2. Set SSL/TLS to "Full (strict)"
3. Enable DDoS protection
4. Configure firewall rules as needed
5. Enable caching for static assets

## Troubleshooting

### Dograh not accessible

```bash
# Check if container is running
docker ps

# View logs
docker compose logs -f

# Check port binding
sudo netstat -tlnp | grep 3010
```

### Cloudflare tunnel connection issues

```bash
# Test tunnel
cloudflared tunnel test dograh-ai

# View tunnel status
cloudflared tunnel info dograh-ai

# Restart tunnel
sudo systemctl restart cloudflared
```

### DNS not resolving

1. Wait 24 hours for DNS propagation
2. Clear browser cache and DNS cache
3. Test with: `nslookup dograh.YOUR_DOMAIN.com`

## Maintenance

### Update Dograh

```bash
# Pull latest image
docker pull ghcr.io/dograh-hq/dograh:latest

# Restart container
docker compose restart
```

### View logs

```bash
docker compose logs -f
```

### Stop Dograh

```bash
docker compose down
```

## Performance Tips

1. **Enable Cloudflare caching**: Cache static assets
2. **Use HTTP/2**: Enabled by default with Cloudflare
3. **Monitor performance**: Use Cloudflare Analytics dashboard
4. **Scale resources**: Upgrade VPS if needed

## Security Considerations

- Keep Docker images updated
- Use strong Cloudflare API tokens
- Enable firewall rules for additional protection
- Monitor logs regularly
- Use HTTPS only (Cloudflare enforces this)
- Backup your data regularly

## Resources

- [Dograh Documentation](https://docs.dograh.com)
- [Dograh GitHub](https://github.com/dograh-hq/dograh)
- [Dograh Website](https://dograh.com)
- [Cloudflare Tunnel Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide/)

## License

Dograh is licensed under BSD 2-Clause License.

## Support

- Join [Dograh Community Slack](https://join.slack.com/t/dograh-community/shared_invite/zt-3czr47sw5-MSg1J0kJ7IMPOCHF~03auQ)
- GitHub Issues: [dograh-hq/dograh](https://github.com/dograh-hq/dograh/issues)
- Documentation: [docs.dograh.com](https://docs.dograh.com)

---

**Created with ❤️ for the Dograh community**
