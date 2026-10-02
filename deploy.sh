#!/bin/bash

set -e

if ! command -v ansible &> /dev/null || ! command -v terraform &> /dev/null; then
    echo "Error: Ansible or Terraform is not installed"
    exit 1 
fi

read -p "Before launching webiste make sure nginx config files ansible invenotry and page files are valid (Y/N)" input


if [[ $input == "Y" ]]; then
    read -p "Insert domain name: " domain
    if [[ $domain != "" ]]; then
        export DOMAIN_NAME=$domain
    else
        echo "Wrong domain name"
        exit 1
    fi 

    ansible-playbook playbooks/install-nginx.yaml
    ansible-playbook playbooks/copy-page-files.yaml
    ansible-playbook playbooks/setup-nginx.yaml
fi

