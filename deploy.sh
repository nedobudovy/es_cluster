#!/bin/bash

# Function to check if a command is installed
check_command() {
    local cmd=$1
    local name=$2
    if command -v "$cmd" &>/dev/null; then
        version=$($cmd --version 2>/dev/null || echo "Version not available")
        echo "$name is installed: $version"
        return 0
    else
        echo "Error: $name is NOT installed"
        exit 1
    fi
}

# Check for Vagrant, VirtualBox, and Ansible
echo "Checking installed tools..."
echo "-------------------------"
check_command "vagrant" "Vagrant"
check_command "vboxmanage" "VirtualBox"
check_command "ansible" "Ansible"
echo "-------------------------"
echo "All tools are installed successfully"

# Generating key for access to the VM's and for ansible
ssh-keygen -q -t rsa -b 4096 -f ~/.ssh/es_cluster -N ""

# Installing the dependencies
pip install elasticsearch

# Starting this bad boy (Vagrant)
vagrant up

ansible-playbook ./playbooks/elasticsearch.yml
