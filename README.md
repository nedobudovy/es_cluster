# 🚀 ELK Stack Deployment with HTTPS & Nginx Reverse Proxy

[![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Elasticsearch](https://img.shields.io/badge/Elasticsearch-005571?style=for-the-badge&logo=elasticsearch&logoColor=white)](https://www.elastic.co/elasticsearch/)
[![Kibana](https://img.shields.io/badge/Kibana-005571?style=for-the-badge&logo=kibana&logoColor=white)](https://www.elastic.co/kibana/)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org/)

> **A complete, production-ready ELK stack deployment with HTTPS encryption, API key authentication, and Nginx reverse proxy using Ansible automation.**

## ✨ Features

### 🔐 Security First
- **HTTPS Everywhere**: Self-signed certificates for all components
- **API Key Authentication**: Modern token-based authentication for Kibana
- **SSL Termination**: Nginx handles SSL for improved performance  
- **Firewall Configuration**: Automated firewall rules for all services
- **SELinux Support**: Proper SELinux configuration for enterprise environments

### 🏗️ Architecture
- **3-Node Elasticsearch Cluster**: High availability with master-data nodes
- **Kibana Dashboard**: Rich visualization and management interface
- **Nginx Reverse Proxy**: Load balancing and SSL termination
- **Single-File Deployment**: Comprehensive deployment in one playbook

### 🚀 Deployment Options
- **Username/Password Auth**: Traditional authentication method
- **API Key Authentication**: Modern, secure token-based access
- **Development/Production Modes**: Configurable deployment profiles
- **Flexible Configuration**: Override any setting via command line

## 📋 Prerequisites

### System Requirements
- **Operating System**: Fedora/RHEL/CentOS 8+
- **Memory**: Minimum 4GB RAM per Elasticsearch node
- **Disk Space**: At least 20GB free space
- **Network**: SSH access to all target hosts

### Software Dependencies
```bash
# Install Ansible
sudo dnf install ansible

# Install Vagrant (optional, for local testing)
sudo dnf install vagrant virtualbox

# Verify installations
ansible --version
vagrant --version
```

## 🏁 Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd test_project
```

### 2. Configure Inventory
Edit the `inventory` file with your target hosts:
```ini
[es_nodes]
192.168.56.101
192.168.56.102  
192.168.56.103

[kibana]
192.168.56.99

[nginx]
192.168.56.98
```

### 3. Deploy the Stack
```bash
# Standard deployment with username/password authentication
ansible-playbook -i inventory playbooks/deploy.yml

# Deploy with API key authentication
ansible-playbook -i inventory playbooks/deploy.yml -e use_api_key_auth=true

# Production deployment
ansible-playbook -i inventory playbooks/deploy.yml -e deployment_mode=production
```

## 🎯 Access Points

After successful deployment, access your ELK stack via:

| Service | URL | Purpose |
|---------|-----|---------|
| **Elasticsearch** | `https://192.168.56.101:9200` | Direct API access |
| **Kibana (Direct)** | `https://192.168.56.99:5601` | Dashboard access |
| **Kibana (Proxy)** | `https://192.168.56.98` | Load-balanced access |
| **Local (Port Forward)** | `https://localhost:8443` | Development access |

### 🔑 Default Credentials
- **Username**: `elastic`
- **Password**: `change` ⚠️ *Change immediately in production!*

## ⚙️ Configuration Options

### Command Line Variables
```bash
# Authentication method
-e use_api_key_auth=true|false

# Deployment mode  
-e deployment_mode=production|development

# Monitoring
-e enable_monitoring=true|false

# Custom passwords (recommended)
-e vault_elastic_password=your_secure_password
-e vault_kibana_password=your_kibana_password
```

### Inventory Groups
The playbook expects these inventory groups:
- `es_nodes`: Elasticsearch cluster nodes
- `kibana`: Kibana dashboard servers  
- `nginx`: Nginx reverse proxy servers

## 📁 Project Structure

```
test_project/
├── playbooks/
│   └── deploy.yml              # Single-file comprehensive deployment
├── roles/
│   ├── elasticsearch/          # Elasticsearch installation & config
│   ├── kibana/                # Kibana installation & config  
│   └── nginx/                 # Nginx reverse proxy & SSL
├── inventory                  # Target hosts configuration
├── deploy.yml                # Convenient deployment wrapper
├── DEPLOYMENT.md             # Detailed deployment guide
└── README.md                # This file
```

## 🔧 Advanced Usage

### Partial Deployment
Deploy only specific components:
```bash
# Deploy only Elasticsearch
ansible-playbook -i inventory playbooks/deploy.yml --tags elasticsearch

# Deploy only Kibana
ansible-playbook -i inventory playbooks/deploy.yml --tags kibana
```

### Custom SSL Certificates
Replace self-signed certificates with your own:
```bash
# Place certificates in roles/*/files/
# Update certificate paths in group_vars/
```

### Scaling the Cluster
Add more Elasticsearch nodes:
```ini
[es_nodes]
192.168.56.101
192.168.56.102
192.168.56.103
192.168.56.104  # New node
192.168.56.105  # New node
```

## 🐛 Troubleshooting

### Common Issues

#### Connection Refused
```bash
# Check if services are running
sudo systemctl status elasticsearch kibana nginx

# Verify firewall rules
sudo firewall-cmd --list-all

# Check logs
sudo journalctl -u elasticsearch -f
```

#### Certificate Issues
```bash
# Regenerate certificates
sudo rm -rf /etc/elasticsearch/certs/*
ansible-playbook -i inventory playbooks/deploy.yml --tags certificates
```

#### API Key Problems
```bash
# Reset API keys
curl -X DELETE "https://elastic:password@node:9200/_security/api_key/kibana-system-api-key"
ansible-playbook -i inventory playbooks/deploy.yml -e use_api_key_auth=true
```

### Health Checks
```bash
# Elasticsearch cluster health
curl -k -u elastic:password https://node:9200/_cluster/health?pretty

# Kibana status
curl -k https://node:5601/api/status

# Nginx status
curl -k https://proxy/api/status
```

## 📊 Monitoring

### Built-in Health Checks
The deployment includes automatic health verification:
- ✅ Elasticsearch cluster status
- ✅ Kibana connectivity  
- ✅ Nginx proxy functionality
- ✅ SSL certificate validation

### Deployment Summary
After deployment, check `./elk-deployment-summary.md` for:
- Component status and versions
- Access points and credentials
- Security configuration details
- Health check results

## 🤝 Contributing

### Development Setup
```bash
# Fork the repository
git fork <repository-url>

# Create feature branch
git checkout -b feature/awesome-feature

# Make changes and test
ansible-playbook --syntax-check playbooks/deploy.yml

# Submit pull request
git push origin feature/awesome-feature
```

### Testing
```bash
# Syntax validation
ansible-playbook --syntax-check playbooks/deploy.yml

# Dry run
ansible-playbook -i inventory playbooks/deploy.yml --check

# Limited scope testing
ansible-playbook -i inventory playbooks/deploy.yml --limit test_group
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


