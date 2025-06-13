# ELK Stack Single-File Deployment Guide

## Overview

This project now features a **comprehensive single-file deployment** that orchestrates the entire ELK stack with HTTPS security, nginx reverse proxy, and optional API key authentication in one unified playbook.

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Nginx Proxy   │────│     Kibana      │────│ Elasticsearch   │
│   (SSL Term.)   │    │   (HTTPS)       │    │   (HTTPS)       │
│  :443 → :8443   │    │     :5601       │    │     :9200       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Quick Start

### 1. Standard Deployment
```bash
ansible-playbook -i inventory deploy.yml
```

### 2. With API Key Authentication
```bash
ansible-playbook -i inventory deploy.yml -e use_api_key_auth=true
```

### 3. Development Mode
```bash
ansible-playbook -i inventory deploy.yml -e deployment_mode=development
```

## Deployment Phases

The single-file deployment executes in **5 sequential phases**:

### 🔍 Phase 1: Elasticsearch Cluster
- Installs and configures Elasticsearch
- Generates self-signed HTTPS certificates
- Sets up user authentication
- Validates cluster health

### 🔑 Phase 2: API Key Setup (Optional)
- Creates API keys for Kibana authentication
- Configures proper permissions
- Stores keys securely for retrieval

### 🌐 Phase 3: Kibana Deployment
- Installs and configures Kibana with HTTPS
- Configures authentication (username/password or API key)
- Validates connectivity to Elasticsearch

### 🔄 Phase 4: Nginx Reverse Proxy
- Deploys nginx with SSL termination
- Configures reverse proxy to Kibana
- Sets up security headers and redirects

### 🎉 Phase 5: Validation & Summary
- Performs end-to-end connectivity tests
- Generates deployment summary
- Provides access information

## Configuration Options

### Global Variables
```yaml
deployment_mode: "production"     # production, development
use_api_key_auth: false          # Enable API key authentication
enable_monitoring: true          # Enable stack monitoring
es_self_signed_certs: true       # Use self-signed certificates
```

### Password Management
Override default passwords using vault variables:
```bash
ansible-playbook -i inventory deploy.yml \
  -e vault_elastic_password="secure_password" \
  -e vault_kibana_password="kibana_password"
```

## Access Points

After successful deployment:

| Service | URL | Purpose |
|---------|-----|---------|
| **Elasticsearch** | `https://192.168.56.101:9200` | Direct ES access |
| **Kibana (Direct)** | `https://192.168.56.99:5601` | Direct Kibana access |
| **Kibana (Proxy)** | `https://192.168.56.98` | Production access |
| **Local (Forwarded)** | `https://localhost:8443` | Local development |

## Default Credentials

```
Username: elastic
Password: change
```

**⚠️ Important**: Change the default password immediately after deployment!

## Features

### ✅ Security Features
- **HTTPS Everywhere**: All communications encrypted
- **Self-signed Certificates**: Automatic certificate generation
- **API Key Authentication**: Optional modern authentication
- **Security Headers**: Comprehensive nginx security configuration

### ✅ Deployment Features
- **Single Command**: Deploy entire stack with one command
- **Health Checks**: Built-in validation and monitoring
- **Error Recovery**: Robust error handling and retries
- **Detailed Logging**: Comprehensive deployment feedback

### ✅ Operational Features
- **Deployment Summary**: Automatic generation of deployment report
- **Access Validation**: End-to-end connectivity testing
- **Configuration Flexibility**: Multiple deployment modes
- **Rollback Support**: Can redeploy individual components

## Troubleshooting

### Common Issues

1. **Inventory Groups Missing**
   ```
   Error: Required inventory groups (es_nodes, kibana, nginx) must be defined
   ```
   **Solution**: Ensure your inventory file defines all required groups.

2. **Certificate Issues**
   ```
   Error: SSL certificate verification failed
   ```
   **Solution**: Certificates are self-signed. This is expected for development.

3. **API Key Authentication Fails**
   ```
   Error: [config validation of [elasticsearch].api_key]: definition for this key is missing
   ```
   **Solution**: API key format may not be supported. Falls back to username/password auth.

### Validation Commands

```bash
# Check Elasticsearch health
curl -k -u elastic:change https://192.168.56.101:9200/_cluster/health

# Check Kibana status
curl -k https://192.168.56.99:5601/api/status

# Check nginx proxy
curl -k https://192.168.56.98/api/status
```

## File Structure

```
├── deploy.yml                    # Root-level deployment wrapper
├── playbooks/
│   ├── deploy.yml                # Main comprehensive deployment
│   └── setup-api-key-auth.yml   # Standalone API key setup
├── roles/
│   ├── elasticsearch/           # Elasticsearch role
│   ├── kibana/                  # Kibana role
│   └── nginx/                   # Nginx role
└── inventory                    # Inventory configuration
```

## Advanced Usage

### Custom Variables File
```bash
# Create custom vars file
cat > custom-vars.yml <<EOF
deployment_mode: production
use_api_key_auth: true
enable_monitoring: true
custom_domain: "mycompany.com"
EOF

# Deploy with custom variables
ansible-playbook -i inventory deploy.yml -e @custom-vars.yml
```

### Partial Redeployment
```bash
# Redeploy only Kibana
ansible-playbook -i inventory playbooks/deploy.yml --tags kibana

# Redeploy only Nginx
ansible-playbook -i inventory playbooks/deploy.yml --tags nginx
```

### API Key Only Setup
```bash
# Setup API keys without full deployment
ansible-playbook -i inventory playbooks/setup-api-key-auth.yml
```

## Monitoring & Maintenance

### Health Monitoring
The deployment creates an `elk-deployment-summary.md` file with:
- Component status
- Access points
- Security configuration
- Health check results

### Log Locations
- **Elasticsearch**: `/var/log/elasticsearch/`
- **Kibana**: `/var/log/kibana/kibana.log`
- **Nginx**: `/var/log/nginx/`

### Maintenance Commands
```bash
# Restart services
ansible es_nodes -i inventory -m service -a "name=elasticsearch state=restarted" --become
ansible kibana -i inventory -m service -a "name=kibana state=restarted" --become
ansible nginx -i inventory -m service -a "name=nginx state=restarted" --become

# Check service status
ansible all -i inventory -m service -a "name=elasticsearch" --become
```

## Support

For issues or questions:
1. Check the generated `elk-deployment-summary.md`
2. Review the deployment logs
3. Validate inventory configuration
4. Test individual component connectivity

---

**Last Updated**: December 2024  
**Version**: 2.0.0 - Single-File Deployment 