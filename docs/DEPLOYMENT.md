# RNDTBL Deployment Architecture

## Overview

This document describes deployment strategies for the RNDTBL platform, with emphasis on easy integration with existing infrastructure like Neocities, static hosting, and self-hosted environments.

## Deployment Tiers

### Tier 1: Static Site (Minimal Deployment)

**Best for**: Individual users, small groups, documentation export

**Architecture**:
```
User Browser
    ↓
Static HTML/CSS/JS (Neocities/GitHub Pages)
    ↓
Embedded Graph Data (JSON)
    ↓
Client-Side Rendering (D3.js/Cytoscape.js)
```

**Features**:
- No server required
- Free hosting (Neocities, GitHub Pages, Netlify)
- Offline-capable
- Export from full RNDTBL instance

**Limitations**:
- No real-time collaboration
- No server-side search
- Manual updates required
- Limited to smaller graphs (<10k nodes)

**Deployment**:
```bash
# Export RNDTBL graph to static site
rndtbl export --format static --output ./dist

# Deploy to Neocities
neocities push ./dist

# Or deploy to GitHub Pages
git add dist/
git commit -m "Update RNDTBL site"
git push origin gh-pages
```

### Tier 2: Client-Server (Standard Deployment)

**Best for**: Teams, organizations, active collaboration

**Architecture**:
```
User Browsers
    ↓ (WebSocket + HTTPS)
Web Server (Nginx/Caddy)
    ↓
RNDTBL API Server (Node.js/Deno)
    ↓
Graph Database (Neo4j)
    ↓
PostgreSQL (metadata)
    ↓
Redis (cache/sessions)
```

**Features**:
- Real-time collaboration
- Advanced search
- User authentication
- Access control
- Large graphs (millions of nodes)

**Deployment**:
```bash
# Using Docker Compose
docker-compose up -d

# Or using individual containers
docker run -d --name neo4j neo4j:latest
docker run -d --name postgres postgres:14
docker run -d --name redis redis:7
docker run -d --name rndtbl-api rndtbl/api:latest
docker run -d --name rndtbl-web rndtbl/web:latest
```

### Tier 3: Federated (Distributed Deployment)

**Best for**: Large communities, decentralized organizations

**Architecture**:
```
Multiple RNDTBL Instances
    ↓ (Federation Protocol)
Sync Mesh (9P/WebRTC)
    ↓
Local Graph Stores
    ↓
Conflict Resolution (CRDT)
    ↓
Shared Namespace
```

**Features**:
- Decentralized ownership
- Resilient to failures
- Cross-instance search
- Namespace projection
- Offline-first

**Deployment**:
```bash
# Each instance runs independently
rndtbl server --port 8080 --federate --peers peer1.example.com,peer2.example.com

# Enable Plan9 namespace
rndtbl mount --path /rndtbl --9p-port 564

# Connect to other instances
rndtbl peer add --url https://peer1.example.com --key <federation-key>
```

## Deployment Scenarios

### Scenario 1: Personal Knowledge Graph on Neocities

**Setup**:
1. Run local RNDTBL instance for editing
2. Export to static site regularly
3. Upload to Neocities via API or web interface
4. Share public URL

**Configuration**:
```yaml
# rndtbl.config.yml
export:
  format: static
  output: ./neocities-export
  include:
    - graph
    - topics
    - projects
  theme: minimal
  
neocities:
  site_name: myusername
  auto_sync: false  # Manual sync
  api_key: ${NEOCITIES_API_KEY}
```

**Workflow**:
```bash
# Make changes locally
rndtbl edit

# Export when ready
rndtbl export

# Sync to Neocities
rndtbl sync neocities
```

### Scenario 2: Team Collaboration on VPS

**Setup**:
1. Provision VPS (DigitalOcean, Linode, Hetzner)
2. Install Docker and Docker Compose
3. Configure domain and SSL
4. Deploy RNDTBL stack
5. Configure backups

**Server Requirements**:
- CPU: 2+ cores
- RAM: 4GB+ (8GB recommended)
- Storage: 50GB+ SSD
- Network: 100Mbps+

**Docker Compose**:
```yaml
version: '3.8'

services:
  neo4j:
    image: neo4j:5.13
    environment:
      NEO4J_AUTH: neo4j/securepassword
      NEO4J_PLUGINS: '["apoc", "graph-data-science"]'
    volumes:
      - neo4j-data:/data
    ports:
      - "7687:7687"
    
  postgres:
    image: postgres:14
    environment:
      POSTGRES_DB: rndtbl
      POSTGRES_USER: rndtbl
      POSTGRES_PASSWORD: securepassword
    volumes:
      - postgres-data:/var/lib/postgresql/data
    
  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data
    
  api:
    image: rndtbl/api:latest
    environment:
      NEO4J_URI: bolt://neo4j:7687
      POSTGRES_URI: postgresql://rndtbl:securepassword@postgres:5432/rndtbl
      REDIS_URI: redis://redis:6379
      JWT_SECRET: ${JWT_SECRET}
    depends_on:
      - neo4j
      - postgres
      - redis
    ports:
      - "3000:3000"
    
  web:
    image: rndtbl/web:latest
    environment:
      API_URL: http://api:3000
    ports:
      - "8080:80"
    depends_on:
      - api
    
  nginx:
    image: nginx:alpine
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./certs:/etc/nginx/certs
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - web
      - api

volumes:
  neo4j-data:
  postgres-data:
  redis-data:
```

**Nginx Configuration**:
```nginx
server {
    listen 80;
    server_name rndtbl.example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name rndtbl.example.com;
    
    ssl_certificate /etc/nginx/certs/fullchain.pem;
    ssl_certificate_key /etc/nginx/certs/privkey.pem;
    
    # Static site
    location / {
        proxy_pass http://web:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # API
    location /api/ {
        proxy_pass http://api:3000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # WebSocket for real-time
    location /ws {
        proxy_pass http://api:3000/ws;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

### Scenario 3: Federated Community Network

**Setup**:
1. Multiple organizations run their own instances
2. Enable federation between instances
3. Implement namespace projection
4. Configure synchronization rules

**Federation Configuration**:
```yaml
# federation.yml
local:
  instance_id: org-alpha
  public_url: https://rndtbl.org-alpha.org
  namespace: /rndtbl/alpha
  
peers:
  - instance_id: org-beta
    url: https://rndtbl.org-beta.org
    namespace: /rndtbl/beta
    trust_level: full
    sync_topics:
      - climate-change
      - ecology
    
  - instance_id: org-gamma
    url: https://rndtbl.org-gamma.org
    namespace: /rndtbl/gamma
    trust_level: read-only
    
namespace:
  mount_peers: true
  mount_point: /rndtbl/federated
  enable_9p: true
  9p_port: 564
  
sync:
  strategy: crdt
  conflict_resolution: last-write-wins
  batch_size: 100
  interval_seconds: 30
```

**Federation Commands**:
```bash
# Start instance with federation
rndtbl server --config federation.yml

# Add new peer
rndtbl peer add --instance-id org-delta --url https://rndtbl.org-delta.org

# View federation status
rndtbl peer list

# Sync with specific peer
rndtbl sync --peer org-beta

# Mount peer namespace
rndtbl mount --peer org-beta --path /n/beta
```

## Integration Strategies

### Integration with GitHub

**Use Cases**:
- Version control for RNDTBL data
- GitHub Actions for CI/CD
- GitHub Pages for static export
- Issue tracking integration

**GitHub Actions Workflow**:
```yaml
name: Deploy RNDTBL

on:
  push:
    branches: [main]

jobs:
  export-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install RNDTBL CLI
        run: npm install -g @rndtbl/cli
      
      - name: Export static site
        run: rndtbl export --format static --output ./dist
      
      - name: Deploy to Neocities
        run: rndtbl sync neocities
        env:
          NEOCITIES_API_KEY: ${{ secrets.NEOCITIES_API_KEY }}
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./dist
```

### Integration with IPFS

**Benefits**:
- Permanent, immutable storage
- Content-addressed retrieval
- Decentralized hosting
- Censorship resistance

**IPFS Deployment**:
```bash
# Export RNDTBL graph
rndtbl export --format ipfs --output ./ipfs-export

# Add to IPFS
ipfs add -r ./ipfs-export
# Returns: QmHash...

# Pin on Pinata or Infura
curl -X POST "https://api.pinata.cloud/pinning/pinFileToIPFS" \
  -H "pinata_api_key: $PINATA_API_KEY" \
  -H "pinata_secret_api_key: $PINATA_SECRET_KEY" \
  -F "file=@./ipfs-export"

# Access via IPFS gateway
# https://ipfs.io/ipfs/QmHash...
```

### Integration with ActivityPub/Fediverse

**Concept**: RNDTBL instances as ActivityPub actors

**Features**:
- Follow/unfollow RNDTBL topics
- Federate updates across instances
- Comment on nodes via Mastodon/Pleroma
- Cross-platform discovery

**ActivityPub Configuration**:
```yaml
activitypub:
  enabled: true
  instance_actor: https://rndtbl.example.com/actor
  topics_as_actors: true
  federation:
    allow_list:
      - mastodon.social
      - fosstodon.org
    block_list: []
```

## Monitoring and Maintenance

### Health Checks

```bash
# Check system status
rndtbl status

# Check database connectivity
rndtbl health check database

# Check federation peers
rndtbl health check peers

# Monitor performance
rndtbl metrics
```

### Backup Strategy

```bash
# Automated backup script
#!/bin/bash

BACKUP_DIR="/backups/rndtbl-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

# Backup Neo4j
docker exec neo4j neo4j-admin backup --to="$BACKUP_DIR/neo4j"

# Backup PostgreSQL
docker exec postgres pg_dump -U rndtbl rndtbl > "$BACKUP_DIR/postgres.sql"

# Backup configuration
cp -r /opt/rndtbl/config "$BACKUP_DIR/"

# Upload to S3/BackBlaze
aws s3 sync "$BACKUP_DIR" "s3://rndtbl-backups/$(date +%Y%m%d)/"

# Cleanup old backups (keep last 30 days)
find /backups -type d -mtime +30 -exec rm -rf {} +
```

### Monitoring with Prometheus + Grafana

```yaml
# docker-compose.monitoring.yml
services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    ports:
      - "9090:9090"
    
  grafana:
    image: grafana/grafana
    volumes:
      - grafana-data:/var/lib/grafana
    ports:
      - "3001:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: admin
    
  node-exporter:
    image: prom/node-exporter
    ports:
      - "9100:9100"

volumes:
  prometheus-data:
  grafana-data:
```

## Security Considerations

### SSL/TLS Configuration

```bash
# Generate SSL certificate with Let's Encrypt
certbot certonly --standalone -d rndtbl.example.com

# Auto-renewal
echo "0 0 * * 0 certbot renew --quiet" | crontab -
```

### Firewall Configuration

```bash
# UFW rules
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp   # SSH
ufw allow 80/tcp   # HTTP
ufw allow 443/tcp  # HTTPS
ufw allow 564/tcp  # 9P (if using Plan9 namespace)
ufw enable
```

### Authentication

```yaml
# auth.yml
authentication:
  providers:
    - local:
        enabled: true
        password_min_length: 12
        require_email_verification: true
    
    - oauth:
        enabled: true
        providers:
          - github
          - gitlab
          - google
    
    - saml:
        enabled: false
        
  jwt:
    secret: ${JWT_SECRET}
    expiry: 24h
    
  rate_limiting:
    enabled: true
    max_requests: 100
    window_seconds: 60
```

## Cost Estimates

### Static Deployment (Neocities)
- **Cost**: Free (or $5/month for Supporter)
- **Capacity**: 1GB storage, unlimited bandwidth
- **Best for**: Personal projects, documentation

### VPS Deployment
- **Small** (2GB RAM, 1 CPU): $10-20/month
- **Medium** (4GB RAM, 2 CPU): $20-40/month
- **Large** (8GB RAM, 4 CPU): $40-80/month

### Cloud Deployment (AWS/GCP/Azure)
- **Compute**: $50-500/month depending on scale
- **Database**: $30-300/month
- **Storage**: $20-100/month
- **Total**: $100-900/month

### Self-Hosted
- **Hardware**: $500-2000 one-time
- **Electricity**: $10-30/month
- **Internet**: $50-100/month
- **Maintenance**: DIY or $100+/month

## Conclusion

RNDTBL's flexible architecture supports multiple deployment models, from simple static sites on Neocities to complex federated networks. Choose the deployment tier that matches your needs and scale up as required.

The static export capability ensures that knowledge remains accessible even without server infrastructure, while federation support enables distributed ownership and resilience.

---

*Last Updated: 2025-10-27*
