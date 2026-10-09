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
        export TF_VAR_DOMAIN_NAME="$domain"
    else
        echo "Wrong domain name"
        exit 1
    fi 

    ansible-playbook playbooks/install-nginx.yaml
    ansible-playbook playbooks/copy-page-files.yaml
    terraform -chdir=cloudflare init
    terraform -chdir=cloudflare apply

    export TLS_CERTIFICATE_PEM="$(terraform -chdir=cloudflare output -raw origin_certificate_pem)"
    export TLS_PRIVATE_KEY_PEM="$(terraform -chdir=cloudflare output -raw origin_private_key_pem)"

    ansible-playbook playbooks/copy-tls-materials.yaml
    ansible-playbook playbooks/setup-nginx.yaml
    ansible-playbook playbooks/create-user.yaml
    ansible-playbook playbooks/disable-root-password-access.yaml
fi
